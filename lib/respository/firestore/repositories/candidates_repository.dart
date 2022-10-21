import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hireway/respository/firestore/firestore_collections.dart';
import 'package:hireway/respository/firestore/firestore_converters.dart';
import 'package:hireway/respository/firestore/firestore_documents.dart';
import 'package:hireway/respository/firestore/objects/candidate.dart';
import 'package:hireway/respository/firestore/repositories/repository_helper.dart';
import 'package:hireway/respository/virtual/virtual_db.dart';
import 'package:synchronized/synchronized.dart';

class CandidatesRepository {
  final VirtualDB _candidates = VirtualDB("candidates");
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _candidatesSubscription;

  bool _subscribed = false;
  final Lock _lock = Lock();

  static final CandidatesRepository _repo =
      CandidatesRepository._privateConstructor();

  CandidatesRepository._privateConstructor();

  factory CandidatesRepository() {
    return _repo;
  }

  Future<List<Candidate>> getAll(
      {bool sortByAddedOnDateTime = false, bool descending = false}) async {
    await _repo._subscribe();
    final candidatesListDB = await _candidates.list();
    final candidatesList =
        candidatesListDB.map((item) => Candidate.fromJson(item)).toList();
    if (sortByAddedOnDateTime) {
      int compareTo(Candidate a, Candidate b) =>
          a.addedOnDateTime.compareTo(b.addedOnDateTime);
      candidatesList.sort((Candidate a, Candidate b) =>
          descending ? compareTo(b, a) : compareTo(a, b));
    }
    return candidatesList;
  }

  Future<Candidate?> getOne(String emailId) async {
    await _repo._subscribe();
    final candidate = await _candidates.findOne("email", emailId);
    return candidate.isNotEmpty ? Candidate.fromJson(candidate) : null;
  }

  Future<void> insert(Candidate candidate) async {
    await _repo._subscribe();
    String businessName = await getBusinessName();
    withCandidateDocumentConverter(
            getCandidateDocument(businessName, candidate.email))
        .set(candidate);
    await _candidates.insert(candidate.toJson());

    getCandidateMetaDocument(businessName).set({
      "candidates":
          FieldValue.arrayUnion(["${candidate.name},${candidate.email}"])
    }, SetOptions(merge: true));
  }

  Future<void> update(Candidate candidate) async {
    await _repo._subscribe();
    String businessName = await getBusinessName();
    withCandidateDocumentConverter(
            getCandidateDocument(businessName, candidate.email))
        .set(candidate, SetOptions(merge: true));
    await _candidates.update(candidate.toJson(), "email", candidate.email);
  }

  Future<List<String>> candidatesList() async {
    await _repo._subscribe();
    return _candidates.getMetaList("candidates");
  }

  Future<void> _subscribe() async {
    await _lock.synchronized(() async {
      if (!_subscribed) {
        await _candidatesSubscribe();
        _subscribed = true;
      }
    });
  }

  Future<void> _unsubscribe() async {
    _candidatesSubscription.cancel();
  }

  Future<void> _candidatesSubscribe() async {
    String businessName = await getBusinessName();
    final Stream<QuerySnapshot<Map<String, dynamic>>> candidates =
        candidatesCollectionRef(businessName).snapshots();
    _candidatesSubscription = candidates
        .listen((event) => populateVirtualDb(event, _candidates, "email"));

    final Stream<DocumentSnapshot<Map<String, dynamic>>> candidatesMetadata =
        getCandidateMetaDocument(businessName).snapshots();
    candidatesMetadata
        .listen((event) => populateMetadataVirtualDB(event, _candidates));

    await candidates.first;
    await candidatesMetadata.first;
  }
}
