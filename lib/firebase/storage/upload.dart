import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:milkyway/firebase/candidate/create.dart';

Future<String?> selectFile(String clientName, String candidateName) async {
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

  if (result != null) {
    return result.files.single.name;
  } else {
    return null;
  }
}

void selectAndUploadFile(String clientName, String candidateName) async {
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

  if (result != null) {
    final storageRef = FirebaseStorage.instance.ref();
    final resumeRef = storageRef.child('$clientName/$candidateName/resume.pdf');

    Uint8List? fileBytes = result.files.single.bytes;
    if (fileBytes != null) {
      final fileSize = result.files.single.size;
      if (fileSize < 5 * 1024 * 1024) {
        /*resumeRef
            .putData(fileBytes)
            .then((uploadTask) => print(uploadTask.state));
        addCandidate(candidateName, resumeRef.fullPath);*/
      } else {
        print("Max file size supported is 5 MB.");
      }
    }
    //File file = File(result.files.single.path);
  } else {
    print("User canceled the picker");
  }
}
