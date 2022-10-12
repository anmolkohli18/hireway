import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hireway/firebase/firestore/firestore_collections.dart';
import 'package:hireway/respository/firestore/firestore_converters.dart';
import 'package:hireway/respository/firestore/firestore_documents.dart';
import 'package:hireway/respository/firestore/objects/candidate.dart';
import 'package:hireway/respository/firestore/repositories/repository_helper.dart';
import 'package:hireway/respository/virtual/virtual_db.dart';

class CandidatesRepository {
  final VirtualDB _candidates = VirtualDB("candidates");
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _candidatesSubscription;

  bool _subscribed = false;

  static final CandidatesRepository _repo =
      CandidatesRepository._privateConstructor();

  CandidatesRepository._privateConstructor();

  factory CandidatesRepository() {
    return _repo;
  }

  Future<List<Candidate>> getAll() async {
    await _repo._subscribe();
    final candidatesList = await _candidates.list();
    return candidatesList.map((item) => Candidate.fromJson(item)).toList();
  }

  Future<Candidate?> getOne(String emailId) async {
    await _repo._subscribe();
    final candidate = await _candidates.findOne("email", emailId);
    return candidate.isEmpty ? Candidate.fromJson(candidate) : null;
  }

  Future<void> insert(Candidate candidate) async {
    await _repo._subscribe();
    String businessName = await getBusinessName();
    withCandidateDocumentConverter(
            candidateDocument(businessName, candidate.email))
        .set(candidate);

    candidateMetaDocument(businessName).set({
      "candidates":
          FieldValue.arrayUnion(["${candidate.name},${candidate.email}"])
    }, SetOptions(merge: true));
  }

  Future<void> update(Candidate candidate) async {
    await _repo._subscribe();
    String businessName = await getBusinessName();
    final candidates = withCandidateDocumentConverter(
        candidateDocument(businessName, candidate.email));
    candidates.set(candidate, SetOptions(merge: true));
  }

  Future<List<String>> candidatesList() => _candidates.getMetadata();

  Future<void> _subscribe() async {
    if (!_subscribed) {
      await _candidatesSubscribe();
      _subscribed = true;
    }
  }

  Future<void> _unsubscribe() async {
    _candidatesSubscription.cancel();
  }

  Future<void> _candidatesSubscribe() async {
    String businessName = await getBusinessName();
    final Stream<QuerySnapshot<Map<String, dynamic>>> candidates =
        candidatesCollectionRef(businessName).snapshots();
    _candidatesSubscription = candidates.listen((event) =>
        populateVirtualDb(event, _candidates, "email", "candidates"));
    await candidates.first;
  }
}
