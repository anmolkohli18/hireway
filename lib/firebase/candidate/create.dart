import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:milkyway/firebase/candidate/candidates_firestore.dart';
import 'package:milkyway/firebase/storage/upload.dart';

Future<void> addNewCandidate(
    Candidate candidate, FilePickerResult localResume) async {
  String? resumeFireStorage =
      await uploadFile(candidate.name, localResume, candidate.resume);
  if (resumeFireStorage != null) {
    print("resume uploaded successfully!");
    await candidatesFirestore
        .doc(candidate.email)
        .set(candidate, SetOptions(merge: true))
        .then((value) => print("Candidate Added"))
        .catchError((error) => print("Failed to add candidate $error"));
  }
}
