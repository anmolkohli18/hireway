import 'package:milkyway/firebase/candidate/model.dart';

Future<void> addCandidate(String fullName, String resume) {
  return candidates
      .doc(fullName)
      .set(Candidate(fullName: fullName, resume: resume))
      .then((value) => print("Candidate Added"))
      .catchError((error) => print("Failed to add candidate"));
}
