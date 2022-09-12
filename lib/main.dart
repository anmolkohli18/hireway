import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:milkyway/color.dart';
import 'package:milkyway/candidate/basic_info.dart';
import 'package:milkyway/firebase/auth/email_page.dart';
import 'package:milkyway/firebase/auth/firebase_auth.dart';
import 'package:milkyway/firebase/firebase_config.dart';

void main() async {
  await Firebase.initializeApp(options: FirebaseConfig.platformOptions);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return consoleApp();
  }

  MaterialApp onboardingApp() {
    return MaterialApp(
      title: 'Milky Way',
      theme: ThemeData(
        primarySwatch: primaryOnboardingColor,
        scaffoldBackgroundColor: primaryOnboardingColor,
      ),
      initialRoute: isLoggedIn() ? '/login' : '/',
      routes: {
        '/': (context) => const CandidateBasicInfo(),
        '/login': (context) => const GetEmailForm()
      },
    );
  }

  MaterialApp consoleApp() {
    return MaterialApp(
      title: 'Milky Way',
      theme: ThemeData(
        primarySwatch: primaryConsoleColor,
        scaffoldBackgroundColor: primaryConsoleColor,
      ),
      initialRoute: isLoggedIn() ? '/login' : '/',
      routes: {
        '/': (context) => const CandidateBasicInfo(),
        '/login': (context) => const GetEmailForm()
      },
    );
  }
}
