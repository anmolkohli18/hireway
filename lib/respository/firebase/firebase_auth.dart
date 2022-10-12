import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hireway/main.dart';

String whoAmI() => "${getCurrentUserName()} <${getCurrentUserEmail()}>";

String getCurrentUserName() {
  final auth = FirebaseAuth.instance;
  return auth.currentUser!.displayName!;
}

String getCurrentUserEmail() {
  final auth = FirebaseAuth.instance;
  return auth.currentUser!.email!;
}

bool isLoggedIn(WidgetRef ref) {
  final auth = ref.watch(authStateChangesProvider);
  return auth.asData?.value?.uid != null;
}

void updateDisplayName(String userName) {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    print("Updating user name");
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
      print(user != null ? "${user.email}" : "user is null");
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
