import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hireway/respository/firestore/firestore_converters.dart';
import 'package:hireway/respository/firestore/firestore_documents.dart';
import 'package:hireway/respository/virtual/virtual_db.dart';

Future<void> populateVirtualDb(QuerySnapshot<Map<String, dynamic>> event,
    VirtualDB virtualDb, String idKey) async {
  final List<DocumentChange<Map<String, dynamic>>> documentChanges =
      event.docChanges;
  for (int index = 0; index < documentChanges.length; index++) {
    final Map<String, dynamic> document = documentChanges[index].doc.data()!;
    if (document.containsKey(idKey)) {
      switch (documentChanges[index].type) {
        case DocumentChangeType.added:
          virtualDb.insert(document);
          break;
        case DocumentChangeType.modified:
          virtualDb.update(document, idKey, document[idKey]);
          break;
        case DocumentChangeType.removed:
          virtualDb.remove(idKey, document[idKey]);
          break;
      }
    }
  }
}

Future<void> populateMetadataVirtualDB(
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot,
    VirtualDB virtualDb,
    String metadataKey) async {
  final Map<String, dynamic>? document = documentSnapshot.data();
  if (document != null) {
    final List<String> metadata = (document[metadataKey]! as List<dynamic>)
        .map((e) => e! as String)
        .toList();
    virtualDb.insertMetadata(metadata);
  }
}

Future<String> getBusinessName() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final document =
      await withUserDocumentConverter(userDocument(auth.currentUser!.email!))
          .get();
  return document.data()!.businessName;
}
