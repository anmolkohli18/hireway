import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hireway/respository/firestore/objects/hireway_user.dart';

final userCollection = FirebaseFirestore.instance.collection("users");

final DocumentReference<Map<String, dynamic>> userMetadata =
    userCollection.doc("metadata");

Stream<List<String>> usersStream() async* {
  List<String> kOptions = [];

  try {
    DocumentSnapshot<Map<String, dynamic>> value = await userMetadata.get();

    // TODO change key below to business name
    List<dynamic> users = value.data()!["users"]! as List<dynamic>;
    for (int index = 0; index < users.length; index++) {
      String name = users[index].split(",")[0];
      String email = users[index].split(",")[1];
      kOptions.add("$name <$email>");
    }
  } catch (e) {
    print(e);
  }

  yield kOptions;
}

final userFirestore = userCollection.withConverter(
    fromFirestore: (snapshots, _) => HirewayUser.fromJson(snapshots.data()!),
    toFirestore: (user, _) => user.toJson());
