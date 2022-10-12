import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hireway/respository/firebase/firebase_auth.dart';
import 'package:hireway/respository/firestore/objects/hireway_user.dart';
import 'package:hireway/respository/user_firestore.dart';
import 'package:intl/intl.dart';

final clientCollection = FirebaseFirestore.instance.collection("clients");

// TODO cache it in local variable
Future<String> getBusinessName() async {
  final DocumentSnapshot<HirewayUser> userDoc =
      await userFirestore.doc(getCurrentUserEmail()).get();
  HirewayUser user = userDoc.data()!;
  return user.businessName;
}

void addClient(String businessName, String userEmail, String userName,
    String userRole, String userSkills) {
  clientCollection.doc(businessName).set({});

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String now = dateFormat.format(DateTime.now());

  HirewayUser user = HirewayUser(
      name: userName,
      email: userEmail,
      skills: userSkills,
      available: true,
      businessName: businessName,
      addedOnDateTime: now);
  userFirestore.doc(userEmail).set(user);
  userMetadata.set({
    "users": FieldValue.arrayUnion(["${user.name},${user.email}"])
  }, SetOptions(merge: true));
}
