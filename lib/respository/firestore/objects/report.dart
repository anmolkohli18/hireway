import 'package:flutter/material.dart';

@immutable
class Report {
  const Report(
      {required this.reportId,
      required this.availableInterviewers,
      required this.openRoles,
      required this.totalCandidates});

  final String reportId;
  final int availableInterviewers;
  final int openRoles;
  final int totalCandidates;

  Report.fromJson(Map<String, Object?> json)
      : this(
            reportId: json['reportId']! as String,
            availableInterviewers: json['availableInterviewers']! as int,
            openRoles: json['openRoles']! as int,
            totalCandidates: json['totalCandidates']! as int);

  Map<String, Object?> toJson() {
    return {
      'reportId': reportId,
      'availableInterviewers': availableInterviewers,
      'openRoles': openRoles,
      'totalCandidates': totalCandidates
    };
  }
}
