import 'package:cloud_firestore/cloud_firestore.dart';

DocumentReference<Map<String, dynamic>> clientDocument(String businessName) {
  final documentPath = "clients/$businessName";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> candidateDocument(
    String businessName, String candidateEmail) {
  final documentPath = "clients/$businessName/candidates/$candidateEmail";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> candidateMetaDocument(
    String businessName) {
  final documentPath = "clients/$businessName/candidates/metadata";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> roleDocument(
    String businessName, String title) {
  final documentPath = "clients/$businessName/roles/$title";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> roleMetaDocument(String businessName) {
  final documentPath = "clients/$businessName/roles/metadata";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> scheduleDocument(
    String businessName, String candidateEmail, DateTime startDateTime) {
  final documentPath =
      "clients/$businessName/schedules/$candidateEmail,${startDateTime.toString()}";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> scheduleMetaDocument(
    String businessName) {
  final documentPath = "clients/$businessName/schedules/metadata";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> userDocument(String userEmail) {
  final documentPath = "users/$userEmail";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> userMetaDocument(String businessName) {
  final documentPath = "clients/$businessName/userMetadata/metadata";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> roundDocument(
    String businessName, String roundId) {
  final documentPath = "clients/$businessName/rounds/$roundId";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> roundMetaDocument(String businessName) {
  final documentPath = "clients/$businessName/rounds/metadata";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> reportDocument(
    String businessName, String reportId) {
  final documentPath = "clients/$businessName/reports/$reportId";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> reportMetaDocument(
    String businessName) {
  final documentPath = "clients/$businessName/reports/metadata";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}
