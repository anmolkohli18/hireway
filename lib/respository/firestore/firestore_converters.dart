import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hireway/respository/firestore/objects/candidate.dart';
import 'package:hireway/respository/firestore/objects/hireway_user.dart';
import 'package:hireway/respository/firestore/objects/roles.dart';
import 'package:hireway/respository/firestore/objects/round.dart';
import 'package:hireway/respository/firestore/objects/schedule.dart';

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

DocumentReference<Role> withRoleDocumentConverter(
    DocumentReference<Map<String, dynamic>> document) {
  return document.withConverter(
      fromFirestore: (snapshots, _) => Role.fromJson(snapshots.data()!),
      toFirestore: (role, _) => role.toJson());
}

DocumentReference<Schedule> withScheduleDocumentConverter(
    DocumentReference<Map<String, dynamic>> document) {
  return document.withConverter(
      fromFirestore: (snapshots, _) => Schedule.fromJson(snapshots.data()!),
      toFirestore: (schedule, _) => schedule.toJson());
}

DocumentReference<HirewayUser> withUserDocumentConverter(
    DocumentReference<Map<String, dynamic>> document) {
  return document.withConverter(
      fromFirestore: (snapshots, _) => HirewayUser.fromJson(snapshots.data()!),
      toFirestore: (user, _) => user.toJson());
}

DocumentReference<Round> withRoundDocumentConverter(
    DocumentReference<Map<String, dynamic>> document) {
  return document.withConverter(
      fromFirestore: (snapshots, _) => Round.fromJson(snapshots.data()!),
      toFirestore: (round, _) => round.toJson());
}
