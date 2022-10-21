import 'package:cloud_firestore/cloud_firestore.dart';

DocumentReference<Map<String, dynamic>> getClientDocument(String businessName) {
  final documentPath = "clients/$businessName";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> getCandidateDocument(
    String businessName, String candidateEmail) {
  final documentPath = "clients/$businessName/candidates/$candidateEmail";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> getCandidateMetaDocument(
    String businessName) {
  final documentPath = "clients/$businessName/candidates/metadata";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> getRoleDocument(
    String businessName, String title) {
  final documentPath = "clients/$businessName/roles/$title";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> getRoleMetaDocument(
    String businessName) {
  final documentPath = "clients/$businessName/roles/metadata";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> getScheduleDocument(
    String businessName, String candidateEmail, DateTime startDateTime) {
  final documentPath =
      "clients/$businessName/schedules/$candidateEmail,${startDateTime.toString()}";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> getScheduleMetaDocument(
    String businessName) {
  final documentPath = "clients/$businessName/schedules/metadata";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> getUserDocument(String userEmail) {
  final documentPath = "users/$userEmail";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> getUserMetaDocument(
    String businessName) {
  final documentPath = "clients/$businessName/userMetadata/metadata";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> getRoundDocument(
    String businessName, String roundId) {
  final documentPath = "clients/$businessName/rounds/$roundId";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> getRoundMetaDocument(
    String businessName) {
  final documentPath = "clients/$businessName/rounds/metadata";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> getReportDocument(
    String businessName, String reportId) {
  final documentPath = "clients/$businessName/reports/$reportId";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> getReportMetaDocument(
    String businessName) {
  final documentPath = "clients/$businessName/reports/metadata";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> getSubscriptionDocument(
    String businessName) {
  final documentPath = "subscriptions/$businessName";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}
