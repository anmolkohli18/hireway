import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _interviewerCollection = FirebaseFirestore.instance
    .collection("clients")
    .doc("client-name")
    .collection("interviewer");

final DocumentReference<Map<String, dynamic>> interviewerMetadata =
    _interviewerCollection.doc("metadata");

Stream<List<String>> interviewersList() async* {
  DocumentSnapshot<Map<String, dynamic>> value =
      await interviewerMetadata.get();

  List<String> kOptions = [];

  List<dynamic> interviewers = value.data()!["interviewers"]! as List<dynamic>;
  for (int index = 0; index < interviewers.length; index++) {
    String name = interviewers[index].split(",")[0];
    String email = interviewers[index].split(",")[1];
    kOptions.add("$name <$email>");
  }

  yield kOptions;
}

final interviewerFirestore = _interviewerCollection.withConverter(
    fromFirestore: (snapshots, _) => Interviewer.fromJson(snapshots.data()!),
    toFirestore: (interviewer, _) => interviewer.toJson());

@immutable
class Interviewer {
  const Interviewer({
    required this.name,
    required this.email,
    required this.skills,
    required this.available,
    required this.addedOnDateTime,
  });

  final String name;
  final String email;
  final bool available;
  final String skills;
  final String addedOnDateTime;

  Interviewer.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          email: json['email']! as String,
          available: json['available']! as bool,
          skills: json['skills']! as String,
          addedOnDateTime: json['addedOnDateTime']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'email': email,
      'available': available,
      'skills': skills,
      'addedOnDateTime': addedOnDateTime,
    };
  }
}
