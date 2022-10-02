import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milkyway/console/candidate/add_new_candidate.dart';
import 'package:milkyway/console/enums.dart';
import 'package:milkyway/console/candidate/candidates_list.dart';
import 'package:milkyway/console/interviewers/add_new_interviewer.dart';
import 'package:milkyway/console/interviewers/interviewers_list.dart';
import 'package:milkyway/console/roles/add_new_roles.dart';
import 'package:milkyway/console/roles/roles_list.dart';
import 'package:milkyway/console/schedule/add_new_schedule.dart';
import 'package:milkyway/settings.dart';
import 'package:milkyway/console/homepage.dart';
import 'package:milkyway/console/routes/routing.dart';
import 'package:milkyway/console/schedule/schedule_list.dart';
import 'package:milkyway/firebase/auth/email_page.dart';
import 'package:milkyway/firebase/auth/firebase_auth.dart';

final selectedMenuProvider = StateProvider((ref) => 0);
final candidatesStateProvider =
    StateProvider((ref) => CandidatesState.candidatesList);
final rolesStateProvider = StateProvider((ref) => RolesState.rolesList);
final interviewerStateProvider =
    StateProvider((ref) => InterviewersState.interviewersList);
final scheduleStateProvider =
    StateProvider((ref) => SchedulesState.schedulesList);

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
              cursorColor: primaryButtonColor,
              selectionColor: lightHeadingColor),
          inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryButtonColor)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryButtonColor))),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 40),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: primaryButtonColor))),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  textStyle: const TextStyle(fontSize: 14),
                  backgroundColor: primaryButtonColor,
                  foregroundColor: Colors.white)),
          primarySwatch: primaryConsoleColor,
          scaffoldBackgroundColor: const Color(0xFFF4F6F7),
          colorScheme: const ColorScheme.light(
              background: primaryButtonColor, secondary: secondaryButtonColor)),
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
                const Expanded(child: AddNewCandidate()), settings.name);
          }
        } else if (settings.name!.startsWith('/schedules')) {
          ref.read(selectedMenuProvider.notifier).state = 2;
          if (settings.name == '/schedules') {
            return routing(
                const Expanded(child: SchedulesList()), settings.name);
          } else if (settings.name == '/schedules/new') {
            return routing(
                const Expanded(child: AddNewSchedule()), settings.name);
          }
        } else if (settings.name!.startsWith('/roles')) {
          ref.read(selectedMenuProvider.notifier).state = 3;
          if (settings.name == '/roles') {
            return routing(const Expanded(child: RolesList()), settings.name);
          } else if (settings.name == '/roles/new') {
            return routing(const Expanded(child: AddNewRole()), settings.name);
          }
        } else if (settings.name!.startsWith('/interviewers')) {
          ref.read(selectedMenuProvider.notifier).state = 4;
          if (settings.name == '/interviewers') {
            return routing(
                const Expanded(child: InterviewersList()), settings.name);
          } else if (settings.name == '/interviewers/new') {
            return routing(
                const Expanded(child: AddNewInterviewer()), settings.name);
          }
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
