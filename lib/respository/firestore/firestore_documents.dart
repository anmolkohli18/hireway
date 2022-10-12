import 'package:cloud_firestore/cloud_firestore.dart';

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
    String businessName, String roleName) {
  final documentPath = "clients/$businessName/roles/$roleName";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> roleMetaDocument(String businessName) {
  final documentPath = "clients/$businessName/roles/metadata";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}

DocumentReference<Map<String, dynamic>> userDocument(String userEmail) {
  final documentPath = "users/$userEmail";
  final document = FirebaseFirestore.instance.doc(documentPath);
  return document;
}
