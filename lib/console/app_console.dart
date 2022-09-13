import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milkyway/colors.dart';
import 'package:milkyway/console/candidate/basic_info.dart';
import 'package:milkyway/console/candidates_list.dart';
import 'package:milkyway/console/homepage.dart';
import 'package:milkyway/console/drawer.dart';
import 'package:milkyway/console/routes/routing.dart';
import 'package:milkyway/console/schedule.dart';
import 'package:milkyway/firebase/auth/email_page.dart';
import 'package:milkyway/firebase/auth/firebase_auth.dart';

final selectedMenuProvider = StateProvider((ref) => 0);

class AppConsole extends ConsumerWidget {
  const AppConsole({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Hire Way',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: const TextTheme(
            subtitle1: TextStyle(color: primaryColor),
          ),
          textSelectionTheme: const TextSelectionThemeData(
              cursorColor: primaryButton, selectionColor: lightHeadingColor),
          inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryButton)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryButton))),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 40),
                  primary: primaryButton,
                  side: const BorderSide(color: primaryButton))),
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
          colorScheme: const ColorScheme.light(
              background: primaryButton, secondary: secondaryButton)),
      initialRoute: isLoggedIn() ? '/login' : '/home',
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          ref.read(selectedMenuProvider.notifier).state = 0;
          return routing(const Expanded(child: Homepage()), settings.name);
        } else if (settings.name!.startsWith('/candidates')) {
          ref.read(selectedMenuProvider.notifier).state = 1;
          if (settings.name == '/candidates') {
            return routing(
                const Expanded(child: CandidatesList()), settings.name);
          } else if (settings.name == '/candidates/new') {
            return routing(
                const Expanded(child: CandidateBasicInfo()), settings.name);
          }
        } else if (settings.name == '/schedule') {
          ref.read(selectedMenuProvider.notifier).state = 2;
          return routing(const Expanded(child: SchedulesList()), settings.name);
        } else {
          // TODO change to login screen
          return MyCustomRoute(
              builder: (_) => const GetEmailForm(),
              settings: RouteSettings(name: settings.name));
        }
      },
    );
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({required super.builder, super.settings});

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name != null) return child;
    return FadeTransition(opacity: animation, child: child);
  }
}
