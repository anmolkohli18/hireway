import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:milkyway/firebase/candidate/create.dart';

Future<FilePickerResult?> selectFile(String candidateName, String role) async {
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

  if (result != null) {
    Uint8List? fileBytes = result.files.single.bytes;
    if (fileBytes != null) {
      final fileSize = result.files.single.size;
      if (fileSize < 5 * 1024 * 1024) {
        return result;
      } else {
        print("Max file size supported is 5 MB.");
      }
    }
  } else {
    print("User canceled the picker");
  }
  return null;
}

void uploadFile(String candidateName, String role,
    FilePickerResult filePickerResult) async {
  final storageRef = FirebaseStorage.instance.ref();
  final String resumePath = 'client-name/$candidateName/resume.pdf';
  final resumeRef = storageRef.child(resumePath);

  Uint8List? fileBytes = filePickerResult.files.single.bytes;
  if (fileBytes != null) {
    resumeRef.putData(fileBytes).then((uploadTask) => print(uploadTask.state));
  }
  addResumePath(candidateName, role, resumePath);
}
