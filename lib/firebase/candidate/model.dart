import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final candidates = FirebaseFirestore.instance
    .collection("clients")
    .doc("client-name")
    .collection("candidates")
    .withConverter(
        fromFirestore: (snapshots, _) => Candidate.fromJson(snapshots.data()!),
        toFirestore: (account, _) => account.toJson());

@immutable
class Candidate {
  const Candidate({
    required this.fullName,
    required this.resume,
  });

  final String fullName;
  final String resume;

  Candidate.fromJson(Map<String, Object?> json)
      : this(
            fullName: json['fullName']! as String,
            resume: json['resume']! as String);

  Map<String, Object?> toJson() {
    return {
      'fullName': fullName,
      'resume': resume,
    };
  }
}
