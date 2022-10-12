import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference<Map<String, dynamic>> candidatesCollectionRef(
    String businessName) {
  final collectionPath = "clients/$businessName/candidates";
  final collection = FirebaseFirestore.instance.collection(collectionPath);
  return collection;
}

CollectionReference<Map<String, dynamic>> rolesCollectionRef(
    String businessName) {
  final collectionPath = "clients/$businessName/roles";
  final collection = FirebaseFirestore.instance.collection(collectionPath);
  return collection;
}

Query<Map<String, dynamic>> usersCollectionRef(String businessName) {
  const collectionPath = "users";
  final collection = FirebaseFirestore.instance
      .collection(collectionPath)
      .where("businessName", isEqualTo: businessName);
  return collection;
}

CollectionReference<Map<String, dynamic>> schedulesCollectionRef(
    String businessName) {
  final collectionPath = "clients/$businessName/schedules";
  final collection = FirebaseFirestore.instance.collection(collectionPath);
  return collection;
}

CollectionReference<Map<String, dynamic>> roundsCollectionRef(
    String businessName) {
  final collectionPath = "clients/$businessName/rounds";
  final collection = FirebaseFirestore.instance.collection(collectionPath);
  return collection;
}
