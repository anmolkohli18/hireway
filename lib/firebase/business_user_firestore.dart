import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hireway/firebase/auth/firebase_auth.dart';
import 'package:hireway/firebase/user_firestore.dart';
import 'package:intl/intl.dart';

final clientCollection = FirebaseFirestore.instance.collection("clients");

// TODO cache it in local variable
Future<String> getBusinessName() async {
  final DocumentSnapshot<User> userDoc =
      await userFirestore.doc(getUserDetails().email).get();
  User user = userDoc.data()!;
  return user.businessName;
}

void addClient(String businessName, String userEmail, String userName,
    String userRole, String userSkills) {
  clientCollection.doc(businessName).set({});

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String now = dateFormat.format(DateTime.now());

  User user = User(
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
