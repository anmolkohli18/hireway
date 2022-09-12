import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:googleapis/cloudbuild/v1.dart';
import 'package:milkyway/color.dart';
import 'package:milkyway/candidate/basic_info.dart';
import 'package:milkyway/console/candidates.dart';
import 'package:milkyway/drawer.dart';
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
    return consoleApp(context);
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

  MaterialApp consoleApp(BuildContext context) {
    return MaterialApp(
      title: 'Hire Way',
      theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  textStyle: const TextStyle(fontSize: 14),
                  primary: primaryButton,
                  onPrimary: Colors.white)),
          primarySwatch: primaryConsoleColor,
          scaffoldBackgroundColor: const Color(0xFFF4F6F7),
          colorScheme: const ColorScheme.dark(
              background: primaryButton, secondary: secondaryButton)),
      home: home(context),
    );
  }
}

Widget home(BuildContext context) {
  return Scaffold(
    body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [DrawerWidget(), const Expanded(child: OnboardingSteps())]),
  );
}
