import 'package:flutter/material.dart';

@immutable
class Round {
  const Round({
    required this.uid,
    required this.candidateInfo,
    required this.scheduledOn,
    required this.interviewer,
    required this.rating,
    required this.review,
  });

  final String uid;
  final String candidateInfo;
  final String scheduledOn;
  final String interviewer;
  final double rating;
  final String review;

  Round.fromJson(Map<String, Object?> json)
      : this(
          uid: json['uid']! as String,
          candidateInfo: json['candidateInfo']! as String,
          scheduledOn: json['scheduledOn']! as String,
          interviewer: json['interviewer']! as String,
          rating: json['rating']! as double,
          review: json['review']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'candidateInfo': candidateInfo,
      'scheduledOn': scheduledOn,
      'interviewer': interviewer,
      'rating': rating,
      'review': review,
    };
  }
}
