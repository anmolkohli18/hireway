import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    fromFirestore: (snapshots, _) => User.fromJson(snapshots.data()!),
    toFirestore: (user, _) => user.toJson());

@immutable
class User {
  const User({
    required this.name,
    required this.email,
    required this.skills,
    required this.businessName,
    required this.available,
    required this.addedOnDateTime,
  });

  final String name;
  final String email;
  final String skills;
  final String businessName;
  final bool available;
  final String addedOnDateTime;

  User.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          email: json['email']! as String,
          skills: json['skills']! as String,
          businessName: json['businessName']! as String,
          available: json['available']! as bool,
          addedOnDateTime: json['addedOnDateTime']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'email': email,
      'businessName': businessName,
      'skills': skills,
      'available': available,
      'addedOnDateTime': addedOnDateTime,
    };
  }
}
