import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hireway/respository/firestore/firestore_collections.dart';
import 'package:hireway/respository/firestore/firestore_converters.dart';
import 'package:hireway/respository/firestore/firestore_documents.dart';
import 'package:hireway/respository/firestore/objects/round.dart';
import 'package:hireway/respository/firestore/repositories/repository_helper.dart';
import 'package:hireway/respository/virtual/virtual_db.dart';
import 'package:synchronized/synchronized.dart';

class RoundsRepository {
  final VirtualDB _rounds = VirtualDB("rounds");
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _roundsSubscription;

  bool _subscribed = false;
  final Lock _lock = Lock();

  static final RoundsRepository _repo = RoundsRepository._privateConstructor();

  RoundsRepository._privateConstructor();

  factory RoundsRepository() {
    return _repo;
  }

  Future<List<Round>> getAll() async {
    await _repo._subscribe();
    final roundsList = await _rounds.list();
    return roundsList.map((item) => Round.fromJson(item)).toList();
  }

  Future<List<Round>> getAllWhere(String key, String value) async {
    await _repo._subscribe();
    final roundsList = await _rounds.list();
    return roundsList
        .where((element) => element[key] == value)
        .map((item) => Round.fromJson(item))
        .toList();
  }

  Future<Round?> getOne(String key, String value) async {
    await _repo._subscribe();
    final round = await _rounds.findOne(key, value);
    return round.isNotEmpty ? Round.fromJson(round) : null;
  }

  Future<void> insert(Round round) async {
    await _repo._subscribe();
    String businessName = await getBusinessName();
    withRoundDocumentConverter(roundDocument(businessName, round.uid))
        .set(round);

    roundMetaDocument(businessName).set({
      "rounds": FieldValue.arrayUnion([round.uid])
    }, SetOptions(merge: true));
  }

  Future<void> update(Round round) async {
    await _repo._subscribe();
    String businessName = await getBusinessName();
    final rounds =
        withRoundDocumentConverter(roundDocument(businessName, round.uid));
    rounds.set(round, SetOptions(merge: true));
  }

  Future<List<String>> roundsList() async {
    await _repo._subscribe();
    return _rounds.getMetadata();
  }

  Future<void> _subscribe() async {
    await _lock.synchronized(() async {
      if (!_subscribed) {
        await _roundsSubscribe();
        _subscribed = true;
      }
    });
  }

  Future<void> _unsubscribe() async {
    _roundsSubscription.cancel();
  }

  Future<void> _roundsSubscribe() async {
    String businessName = await getBusinessName();
    final Stream<QuerySnapshot<Map<String, dynamic>>> rounds =
        roundsCollectionRef(businessName).snapshots();
    _roundsSubscription =
        rounds.listen((event) => populateVirtualDb(event, _rounds, "uid"));

    final Stream<DocumentSnapshot<Map<String, dynamic>>> roundsMetadata =
        roundMetaDocument(businessName).snapshots();
    roundsMetadata
        .listen((event) => populateMetadataVirtualDB(event, _rounds, "rounds"));

    await rounds.first;
    await roundsMetadata.first;
  }
}
