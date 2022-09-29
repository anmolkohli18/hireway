import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final rolesFirestore = FirebaseFirestore.instance
    .collection("clients")
    .doc("client-name")
    .collection("roles")
    .withConverter(
        fromFirestore: (snapshots, _) => Role.fromJson(snapshots.data()!),
        toFirestore: (role, _) => role.toJson());

@immutable
class Role {
  const Role({
    required this.title,
    required this.description,
    required this.openings,
    required this.state,
    required this.skills,
    required this.addedOnDateTime,
  });

  final String title;
  final String description;
  final int openings;
  final String state;
  final String skills;
  final String addedOnDateTime;

  Role.fromJson(Map<String, Object?> json)
      : this(
          title: json['title']! as String,
          description: json['description']! as String,
          state: json['state']! as String,
          openings: json['openings']! as int,
          skills: json['skills']! as String,
          addedOnDateTime: json['addedOnDateTime']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'description': description,
      'openings': openings,
      'state': state,
      'skills': skills,
      'addedOnDateTime': addedOnDateTime,
    };
  }
}
