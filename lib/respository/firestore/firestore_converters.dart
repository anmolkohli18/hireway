import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hireway/respository/firestore/objects/candidate.dart';
import 'package:hireway/respository/firestore/objects/hireway_user.dart';

CollectionReference<Candidate> withCandidateCollectionConverter(
    CollectionReference<Map<String, dynamic>> collection) {
  return collection.withConverter(
      fromFirestore: (snapshots, _) => Candidate.fromJson(snapshots.data()!),
      toFirestore: (candidate, _) => candidate.toJson());
}

DocumentReference<Candidate> withCandidateDocumentConverter(
    DocumentReference<Map<String, dynamic>> document) {
  return document.withConverter(
      fromFirestore: (snapshots, _) => Candidate.fromJson(snapshots.data()!),
      toFirestore: (candidate, _) => candidate.toJson());
}

DocumentReference<HirewayUser> withUserDocConverter(
    DocumentReference<Map<String, dynamic>> collection) {
  return collection.withConverter(
      fromFirestore: (snapshots, _) => HirewayUser.fromJson(snapshots.data()!),
      toFirestore: (user, _) => user.toJson());
}
