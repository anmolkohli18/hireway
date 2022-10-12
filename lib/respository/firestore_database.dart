import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hireway/respository/firestore/firestore_collections.dart';
import 'package:hireway/respository/firestore/firestore_converters.dart';
import 'package:hireway/respository/firestore/objects/candidate.dart';
import 'package:hireway/main.dart';
import 'package:hireway/respository/firestore/objects/hireway_user.dart';

class FirestoreDatabase {
  FirestoreDatabase({required this.uid});
  final String uid;

  Future<DocumentSnapshot<HirewayUser>> userDocument(String email) async {
    final CollectionReference<HirewayUser> userCollection =
        FirebaseFirestore.instance.collection("users").withConverter(
            fromFirestore: (snapshots, _) =>
                HirewayUser.fromJson(snapshots.data()!),
            toFirestore: (user, _) => user.toJson());

    final DocumentSnapshot<HirewayUser> userDoc =
        await userCollection.doc(email).get();
    return userDoc;
  }

  Future<String?> getBusinessName(FirebaseAuth auth) async {
    final DocumentSnapshot<HirewayUser> document =
        await userDocument(auth.currentUser!.email!);
    HirewayUser? hirewayUser = document.data();
    print("returning business name ${hirewayUser!.businessName}");
    return hirewayUser!.businessName;
  }

  FutureProvider<String?> businessNameProvider() =>
      FutureProvider<String?>((ref) async {
        final FirebaseAuth auth = ref.watch(firebaseAuthProvider);
        return getBusinessName(auth);
      });

  Provider<StreamController<QuerySnapshot<Candidate>>>
      candidateProfileStreamController(
              String businessName, String candidateEmail) =>
          Provider<StreamController<QuerySnapshot<Candidate>>>((ref) {
            final StreamController<QuerySnapshot<Candidate>> streamController =
                StreamController();
            final CollectionReference<Map<String, dynamic>>
                candidatesCollection = candidatesCollectionRef(businessName);

            streamController.addStream(
                withCandidateCollectionConverter(candidatesCollection)
                    .where("email", isEqualTo: candidateEmail)
                    .snapshots());
            return streamController;
          });
}
