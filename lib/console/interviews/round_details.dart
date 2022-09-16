import 'package:flutter/material.dart';

@immutable
class RoundDetails {
  const RoundDetails({
    required this.number,
    required this.status,
    required this.score,
    required this.feedback,
  });

  final int number;
  final String status;
  final int score;
  final String feedback;

  RoundDetails.fromJson(Map<String, Object?> json)
      : this(
          number: json['number']! as int,
          status: json['status']! as String,
          score: json['score']! as int,
          feedback: json['feedback']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'number': number,
      'status': status,
      'score': score,
      'feedback': feedback,
    };
  }
}
