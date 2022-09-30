import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _scheduleCollection = FirebaseFirestore.instance
    .collection("clients")
    .doc("client-name")
    .collection("schedule");

final scheduleFirestore = _scheduleCollection.withConverter(
    fromFirestore: (snapshots, _) => Schedule.fromJson(snapshots.data()!),
    toFirestore: (schedule, _) => schedule.toJson());

@immutable
class Schedule {
  const Schedule({
    required this.candidateName,
    required this.interviewers,
    required this.startDateTime,
    required this.endDateTime,
    required this.addedOnDateTime,
  });

  final String candidateName;
  final String interviewers;
  final String startDateTime;
  final String endDateTime;
  final String addedOnDateTime;

  Schedule.fromJson(Map<String, Object?> json)
      : this(
          candidateName: json['candidateName']! as String,
          interviewers: json['interviewers']! as String,
          startDateTime: json['startDateTime']! as String,
          endDateTime: json['endDateTime']! as String,
          addedOnDateTime: json['addedOnDateTime']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'candidateName': candidateName,
      'interviewers': interviewers,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'addedOnDateTime': addedOnDateTime,
    };
  }
}
