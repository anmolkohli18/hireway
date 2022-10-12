import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static FirebaseOptions get platformOptions {
    //if (kIsWeb) {
    return const FirebaseOptions(
        apiKey: "AIzaSyAGnxB5iz6LbrF3aH8kQBEHAl4kG49OEQM",
        authDomain: "milkyway-ea606.firebaseapp.com",
        projectId: "milkyway-ea606",
        storageBucket: "milkyway-ea606.appspot.com",
        messagingSenderId: "723181843569",
        appId: "1:723181843569:web:7eb0e0d0c21e1b57df97d0",
        measurementId: "G-QL0RN69WSM");
    //}
  }
}
