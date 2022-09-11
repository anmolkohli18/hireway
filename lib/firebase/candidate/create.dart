import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milkyway/firebase/candidate/model.dart';

Future<void> addCandidate(String fullName, String resume) {
  return candidates
      .doc("candidate-name-or-id")
      .set(Candidate(fullName: fullName, resume: resume),
          SetOptions(merge: true))
      .then((value) => print("Candidate Added"))
      .catchError((error) => print("Failed to add candidate"));
}
