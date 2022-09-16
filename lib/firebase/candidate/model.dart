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
    required this.name,
    required this.role,
    required this.resume,
    required this.email,
    required this.phone,
    required this.skills,
  });

  final String name;
  final String role;
  final String resume;
  final String email;
  final String phone;
  final String skills;

  Candidate.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          role: json['role']! as String,
          resume: json['resume']! as String,
          email: json['email']! as String,
          phone: json['phone']! as String,
          skills: json['skills']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'role': role,
      'resume': resume,
      'email': email,
      'phone': phone,
      'skills': skills,
    };
  }
}
