import 'package:flutter/material.dart';

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
