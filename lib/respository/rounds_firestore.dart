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
    required this.interviewer,
    required this.rating,
    required this.review,
  });

  final String scheduledOn;
  final String interviewer;
  final int rating;
  final String review;

  Round.fromJson(Map<String, Object?> json)
      : this(
          scheduledOn: json['scheduledOn']! as String,
          interviewer: json['interviewer']! as String,
          rating: json['rating']! as int,
          review: json['review']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'scheduledOn': scheduledOn,
      'interviewer': interviewer,
      'rating': rating,
      'review': review,
    };
  }
}
