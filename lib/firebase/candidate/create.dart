import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milkyway/firebase/candidate/model.dart';

// TODO add other fields
Future<void> addNewCandidate(Candidate candidate) {
  return candidates
      .doc("${candidate.name}-${candidate.role}")
      .set(candidate, SetOptions(merge: true))
      .then((value) => print("Candidate Added"))
      .catchError((error) => print("Failed to add candidate"));
}

Future<void> addResumePath(String fullName, String role, String resumePath) {
  return candidates
      .doc("$fullName-$role")
      .set(
          // TODO
          Candidate(
              name: fullName,
              role: role,
              resume: resumePath,
              email: '',
              phone: '',
              skills: ''),
          SetOptions(merge: true))
      .then((value) => print("Resume of the candidate Added"))
      .catchError((error) => print("Failed to add candidate"));
}
