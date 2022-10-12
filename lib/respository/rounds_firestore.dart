import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hireway/respository/firestore/objects/round.dart';

CollectionReference<Round> roundsFirestore(String email) =>
    FirebaseFirestore.instance
        .collection("clients")
        .doc("client-name")
        .collection("candidates")
        .doc(email)
        .collection("rounds")
        .withConverter(
            fromFirestore: (snapshots, _) => Round.fromJson(snapshots.data()!),
            toFirestore: (round, _) => round.toJson());
