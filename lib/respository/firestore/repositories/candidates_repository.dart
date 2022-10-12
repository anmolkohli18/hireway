import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hireway/firebase/firestore/firestore_collections.dart';
import 'package:hireway/respository/firestore/firestore_converters.dart';
import 'package:hireway/respository/firestore/firestore_documents.dart';
import 'package:hireway/respository/firestore/objects/candidate.dart';
import 'package:hireway/respository/virtual/virtual_db.dart';

class CandidatesRepository {
  final VirtualDB _candidates = VirtualDB();
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
    final candidate = await _candidates.findOne("email", emailId);
    return candidate.isEmpty ? Candidate.fromJson(candidate) : null;
  }

  Future<void> insert(Candidate candidate) async {
    String businessName = await _businessName();
    final candidateDoc = withCandidateDocumentConverter(
        candidateDocument(businessName, candidate.email));
    candidateDoc.set(candidate);

    final CollectionReference<Map<String, dynamic>> candidatesCollection =
        candidatesCollectionRef(businessName);
    candidatesCollection.doc("metadata").set({
      "candidates":
          FieldValue.arrayUnion(["${candidate.name},${candidate.email}"])
    }, SetOptions(merge: true));
  }

  Future<void> update(Candidate candidate) async {
    String businessName = await _businessName();
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
    String businessName = await _businessName();
    final Stream<QuerySnapshot<Map<String, dynamic>>> candidates =
        candidatesCollectionRef(businessName).snapshots();
    _candidatesSubscription = candidates.listen(populateVirtualDb);
    await candidates.first;
  }

  Future<void> populateVirtualDb(
      QuerySnapshot<Map<String, dynamic>> event) async {
    final List<DocumentChange<Map<String, dynamic>>> documentChanges =
        event.docChanges;
    for (int index = 0; index < documentChanges.length; index++) {
      final Map<String, dynamic> document = documentChanges[index].doc.data()!;
      if (document.containsKey("email")) {
        switch (documentChanges[index].type) {
          case DocumentChangeType.added:
            _candidates.insert(document);
            break;
          case DocumentChangeType.modified:
            _candidates.update(document, "email", document["email"]);
            break;
          case DocumentChangeType.removed:
            _candidates.remove("email", document["email"]);
            break;
        }
      } else {
        final List<String> candidatesList =
            (document["candidates"]! as List<dynamic>)
                .map((e) => e! as String)
                .toList();
        _candidates.insertMetadata(candidatesList);
      }
    }
  }

  static Future<String> _businessName() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final document =
        await withUserDocConverter(userDocument(auth.currentUser!.email!))
            .get();
    return document.data()!.businessName;
  }
}
