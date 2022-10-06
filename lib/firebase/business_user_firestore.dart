import 'package:cloud_firestore/cloud_firestore.dart';

final clientCollection = FirebaseFirestore.instance.collection("clients");

void addClient(
    String businessName, String userEmail, String userName, String userRole) {
  clientCollection.doc(businessName).set({});
  clientCollection
      .doc(businessName)
      .collection("users")
      .doc(userEmail)
      .set({"userName": userName, "userRole": userRole});
}
