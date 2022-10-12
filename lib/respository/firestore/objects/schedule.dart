import 'package:flutter/material.dart';

@immutable
class Schedule {
  const Schedule(
      {required this.candidateInfo,
      required this.interviewers,
      required this.startDateTime,
      required this.duration,
      required this.addedOnDateTime});

  final String candidateInfo;
  final String interviewers;
  final DateTime startDateTime;
  final String duration;
  final String addedOnDateTime;

  Schedule.fromJson(Map<String, Object?> json)
      : this(
          candidateInfo: json['candidateInfo']! as String,
          interviewers: json['interviewers']! as String,
          startDateTime: DateTime.parse(json['startDateTime'] as String),
          duration: json['duration']! as String,
          addedOnDateTime: json['addedOnDateTime']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'candidateInfo': candidateInfo,
      'interviewers': interviewers,
      'startDateTime': startDateTime.toString(),
      'duration': duration,
      'addedOnDateTime': addedOnDateTime,
    };
  }
}
