import 'package:firebase_auth/firebase_auth.dart';
import 'package:hireway/firebase/auth/hireway_user.dart';

String whoAmI() {
  final userDetails = getUserDetails();
  return "${userDetails.name} <${userDetails.email}>";
}

void firebaseAuth() {
  FirebaseAuth auth = FirebaseAuth.instance;
  auth.authStateChanges().listen((User? user) {
    if (user == null) {
      print("User is currently signed out!");
    } else {
      print("User ${user.displayName} ${user.email} is signed in!");
    }
  });
}

HirewayUser getUserDetails() {
  return HirewayUser(
      name: FirebaseAuth.instance.currentUser!.displayName!,
      email: FirebaseAuth.instance.currentUser!.email!);
}

bool isLoggedIn() => FirebaseAuth.instance.currentUser != null;

void updateDisplayName(String userName) {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    user.updateDisplayName(userName);
  }
}

void createUserAccount(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      print("User ${user.displayName} ${user.email} is signed in!");
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      User? user = await signInUser(email, password);
    }
  } catch (e) {
    print(e);
  }
}

Future<User?> signInUser(String email, String password) async {
  try {
    //SuperSecretPassword!
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
  return Future<User?>.value(null);
}
