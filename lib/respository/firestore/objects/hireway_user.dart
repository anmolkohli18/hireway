import 'package:flutter/material.dart';

@immutable
class HirewayUser {
  const HirewayUser({
    required this.name,
    required this.email,
    required this.skills,
    required this.userRole,
    required this.businessName,
    required this.available,
    required this.addedOnDateTime,
  });

  final String name;
  final String email;
  final String skills;
  final String userRole;
  final String businessName;
  final bool available;
  final String addedOnDateTime;

  HirewayUser.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          email: json['email']! as String,
          skills: json['skills']! as String,
          userRole: json['userRole']! as String,
          businessName: json['businessName']! as String,
          available: json['available']! as bool,
          addedOnDateTime: json['addedOnDateTime']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'email': email,
      'businessName': businessName,
      'skills': skills,
      'userRole': userRole,
      'available': available,
      'addedOnDateTime': addedOnDateTime,
    };
  }
}
