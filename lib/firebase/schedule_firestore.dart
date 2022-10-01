import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milkyway/helper/date_functions.dart';

final _scheduleCollection = FirebaseFirestore.instance
    .collection("clients")
    .doc("client-name")
    .collection("schedule");

final scheduleFirestore = _scheduleCollection.withConverter(
    fromFirestore: (snapshots, _) => Schedule.fromJson(snapshots.data()!),
    toFirestore: (schedule, _) => schedule.toJson());

String computeScheduleState(DateTime startDateTime) {
  final scheduleDate = getDate(startDateTime);

  if (isToday(scheduleDate)) {
    return "today";
  } else if (isTomorrow(scheduleDate)) {
    return "tomorrow";
  } else if (isThisWeek(scheduleDate)) {
    return "this_week";
  } else {
    return "everything_else";
  }
}

@immutable
class Schedule {
  const Schedule._(this.candidateInfo, this.interviewers, this.startDateTime,
      this.duration, this.addedOnDateTime, this.state);

  factory Schedule(
    String candidateInfo,
    String interviewers,
    DateTime startDateTime,
    String duration,
    String addedOnDateTime,
  ) {
    String state = computeScheduleState(startDateTime);
    return Schedule._(candidateInfo, interviewers, startDateTime, duration,
        addedOnDateTime, state);
  }

  final String candidateInfo;
  final String interviewers;
  final DateTime startDateTime;
  final String duration;
  final String addedOnDateTime;
  final String state;

  Schedule.fromJson(Map<String, Object?> json)
      : this._(
            json['candidateInfo']! as String,
            json['interviewers']! as String,
            DateTime.parse(json['startDateTime'] as String),
            json['duration']! as String,
            json['addedOnDateTime']! as String,
            computeScheduleState(
                DateTime.parse(json['startDateTime']! as String)));

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
