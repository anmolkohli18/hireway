import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milkyway/firebase/candidate/model.dart';

Future<void> addNewCandidate(Candidate candidate) {
  return candidates
      .doc("${candidate.fullName}-${candidate.role}")
      .set(candidate, SetOptions(merge: true))
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
