import 'package:firebase_auth/firebase_auth.dart';

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

bool isLoggedIn() {
  return FirebaseAuth.instance.currentUser != null;
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
    }
  } catch (e) {
    print(e);
  }
}

void signInUser() async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: "anmol.kohli18@gmail.com", password: "SuperSecretPassword!");
    print(
        "User ${userCredential.user!.displayName} ${userCredential.user!.email} is signed in!");
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}
