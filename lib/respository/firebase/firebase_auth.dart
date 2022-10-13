import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hireway/console/enums.dart';

String whoAmI() => "${getCurrentUserName()},${getCurrentUserEmail()}";

String getCurrentUserName() {
  final auth = FirebaseAuth.instance;
  return auth.currentUser!.displayName!;
}

String getCurrentUserEmail() {
  final auth = FirebaseAuth.instance;
  return auth.currentUser!.email!;
}

bool isLoggedIn(WidgetRef ref) => FirebaseAuth.instance.currentUser != null;

void updateDisplayName(String userName) {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    user.updateDisplayName(userName);
  }
}

Future<UserAccountState> createUserAccountOrSignIn(
    String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
    return UserAccountState.accountCreated;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return UserAccountState.weakPassword;
    } else if (e.code == 'email-already-in-use') {
      User? user = await signInUser(email, password);
      if (user != null) {
        return UserAccountState.signedIn;
      }
    }
  } catch (e) {
    return UserAccountState.unableToCreateAccount;
  }
  return UserAccountState.unableToCreateAccount;
}

Future<User?> signInUser(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return null;
    } else if (e.code == 'wrong-password') {
      return null;
    }
  }
  return null;
}

Future<void> signOut() async => FirebaseAuth.instance.signOut();
