import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final candidatesCollection = FirebaseFirestore.instance
    .collection("clients")
    .doc("client-name")
    .collection("candidates");

final candidatesFirestore = candidatesCollection.withConverter(
    fromFirestore: (snapshots, _) => Candidate.fromJson(snapshots.data()!),
    toFirestore: (candidate, _) => candidate.toJson());

final candidateMetadata = candidatesCollection.doc("metadata");

Stream<List<String>> candidatesList() async* {
  DocumentSnapshot<Map<String, dynamic>> value = await candidateMetadata.get();

  List<String> kOptions = [];

  List<dynamic> candidates = value.data()!["candidates"]! as List<dynamic>;
  for (int index = 0; index < candidates.length; index++) {
    String name = candidates[index].split(",")[0].toString().trim();
    String email = candidates[index].split(",")[1].toString().trim();
    kOptions.add("$name <$email>");
  }

  yield kOptions;
}

@immutable
class Candidate {
  const Candidate({
    required this.name,
    required this.role,
    required this.resume,
    required this.email,
    required this.phone,
    required this.skills,
    required this.addedOnDateTime,
    required this.interviewStage,
  });

  final String name;
  final String role;
  final String resume;
  final String email;
  final String phone;
  final String skills;
  final String addedOnDateTime;
  final String interviewStage;

  Candidate.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          role: json['role']! as String,
          resume: json['resume']! as String,
          email: json['email']! as String,
          phone: json['phone']! as String,
          skills: json['skills']! as String,
          addedOnDateTime: json['addedOnDateTime']! as String,
          interviewStage: json['interviewStage']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'role': role,
      'resume': resume,
      'email': email,
      'phone': phone,
      'skills': skills,
      'addedOnDateTime': addedOnDateTime,
      'interviewStage': interviewStage,
    };
  }
}
