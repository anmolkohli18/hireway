import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

@immutable
class Round {
  const Round({
    required this.scheduledOn,
    required this.interviewers,
    required this.notes,
    required this.rating,
    required this.summary,
  });

  final String scheduledOn;
  final String interviewers;
  final String notes;
  final String rating;
  final String summary;

  Round.fromJson(Map<String, Object?> json)
      : this(
          scheduledOn: json['scheduledOn']! as String,
          interviewers: json['interviewers']! as String,
          notes: json['notes']! as String,
          rating: json['rating']! as String,
          summary: json['summary']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'scheduledOn': scheduledOn,
      'interviewers': interviewers,
      'notes': notes,
      'rating': rating,
      'summary': summary,
    };
  }
}
