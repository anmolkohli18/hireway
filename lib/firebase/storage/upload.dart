import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<FilePickerResult?>? selectFile() async {
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

Future<String?> uploadFile(String candidateName,
    FilePickerResult filePickerResult, String resumePath) async {
  Uint8List? fileBytes = filePickerResult.files.single.bytes;
  if (fileBytes != null) {
    final storageRef = FirebaseStorage.instance.ref();
    final resumeRef = storageRef.child(resumePath);
    resumeRef.putData(fileBytes).then((uploadTask) => print(uploadTask.state));
    return resumePath;
  }
  return null;
}
