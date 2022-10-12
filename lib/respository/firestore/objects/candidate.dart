import 'package:flutter/material.dart';

@immutable
class Candidate {
  const Candidate(
      {required this.name,
      required this.role,
      required this.resume,
      required this.email,
      required this.phone,
      required this.skills,
      required this.addedOnDateTime,
      required this.interviewStage,
      required this.hiredOrRejectedOn,
      required this.hiringManager});

  final String name;
  final String role;
  final String resume;
  final String email;
  final String phone;
  final String skills;
  final String addedOnDateTime;
  final String interviewStage;
  final String hiredOrRejectedOn;
  final String hiringManager;

  Candidate.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          role: json['role']! as String,
          resume: json['resume']! as String,
          email: json['email']! as String,
          phone: json['phone']! as String,
          skills: json['skills']! as String,
          addedOnDateTime: json['addedOnDateTime']! as String,
          interviewStage: json['interviewStage']! as String,
          hiredOrRejectedOn: json["hiredOrRejectedOn"]! as String,
          hiringManager: json['hiringManager']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'role': role,
      'resume': resume,
      'email': email,
      'phone': phone,
      'skills': skills,
      'addedOnDateTime': addedOnDateTime,
      'interviewStage': interviewStage,
      'hiredOrRejectedOn': hiredOrRejectedOn,
      'hiringManager': hiringManager
    };
  }
}
