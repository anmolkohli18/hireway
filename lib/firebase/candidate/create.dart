import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milkyway/firebase/candidate/model.dart';

Future<void> addCandidate(String fullName, String role) {
  return candidates
      .doc("$fullName-$role")
      .set(Candidate(fullName: fullName, role: role, resume: ""),
          SetOptions(merge: true))
      .then((value) => print("Candidate Added"))
      .catchError((error) => print("Failed to add candidate"));
}

Future<void> addResumePath(String fullName, String role, String resumePath) {
  return candidates
      .doc("$fullName-$role")
      .set(Candidate(fullName: fullName, role: role, resume: resumePath),
          SetOptions(merge: true))
      .then((value) => print("Resume of the candidate Added"))
      .catchError((error) => print("Failed to add candidate"));
}
