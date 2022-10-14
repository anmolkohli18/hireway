import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hireway/auth/email_page.dart';
import 'package:hireway/auth/password_page.dart';
import 'package:hireway/console/candidate/add_new_candidate.dart';
import 'package:hireway/console/candidate/candidate_profile.dart';
import 'package:hireway/console/enums.dart';
import 'package:hireway/console/candidate/candidates_list.dart';
import 'package:hireway/console/users/invite_new_user.dart';
import 'package:hireway/console/users/users_list.dart';
import 'package:hireway/console/roles/add_new_roles.dart';
import 'package:hireway/console/roles/roles_list.dart';
import 'package:hireway/console/schedule/add_new_schedule.dart';
import 'package:hireway/settings.dart';
import 'package:hireway/console/homepage.dart';
import 'package:hireway/console/routes/routing.dart';
import 'package:hireway/console/schedule/schedule_list.dart';
import 'package:hireway/respository/firebase/firebase_auth.dart';

final selectedMenuProvider = StateProvider((ref) => 0);
final candidatesStateProvider =
    StateProvider((ref) => CandidatesState.candidatesList);
final rolesStateProvider = StateProvider((ref) => RolesState.rolesList);
final userStateProvider = StateProvider((ref) => UsersState.usersList);
final scheduleStateProvider =
    StateProvider((ref) => SchedulesState.schedulesList);

class AppConsole extends ConsumerStatefulWidget {
  const AppConsole({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppConsoleState();
}

class _AppConsoleState extends ConsumerState<AppConsole> {
  @override
  Widget build(BuildContext context) {
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
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
      initialRoute: isLoggedIn(ref) ? '/home' : '/signup',
      onGenerateRoute: (RouteSettings settings) {
        if (isLoggedIn(ref)) {
          return appConsoleRoute(settings);
        } else if (settings.name!.startsWith('/signup?email=')) {
          final String userEmail = settings.name!.split("=")[1];
          return MyCustomRoute(
              builder: (_) => CreatePasswordForm(
                    email: userEmail,
                    isLoginFlow: false,
                  ),
              settings: RouteSettings(name: settings.name));
        } else if (settings.name == '/login') {
          return MyCustomRoute(
              builder: (_) => const GetEmailForm(
                    isLoginFlow: true,
                  ),
              settings: RouteSettings(name: settings.name));
        } else {
          return MyCustomRoute(
              builder: (_) => const GetEmailForm(
                    isLoginFlow: false,
                  ),
              settings: RouteSettings(name: settings.name));
        }
      },
    );
  }

  MyCustomRoute appConsoleRoute(RouteSettings settings) {
    if (settings.name == '/home') {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(selectedMenuProvider.notifier).state = 0;
      });
      return routing(const Expanded(child: Homepage()), settings.name);
    } else if (settings.name!.startsWith('/candidates')) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(selectedMenuProvider.notifier).state = 1;
      });
      if (settings.name == '/candidates') {
        return routing(const Expanded(child: CandidatesList()), settings.name);
      } else if (settings.name == '/candidates/new') {
        return routing(const Expanded(child: AddNewCandidate()), settings.name);
      } else if (settings.name!.startsWith('/candidates?name=')) {
        final String candidateName =
            settings.name!.split("=")[1].split("&")[0].replaceAll("%20", " ");
        final String candidateEmail = settings.name!.split("=")[2];
        return routing(
            Expanded(
                child: CandidateProfile(
              name: candidateName,
              email: candidateEmail,
            )),
            settings.name);
      }
    } else if (settings.name!.startsWith('/schedules')) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(selectedMenuProvider.notifier).state = 2;
      });
      if (settings.name == '/schedules') {
        return routing(const Expanded(child: SchedulesList()), settings.name);
      } else if (settings.name == '/schedules/new') {
        final String candidateInfo = settings.arguments != null
            ? (settings.arguments as Map<String, String>)["info"]!
            : "";
        return routing(
            Expanded(
                child: AddNewSchedule(
              info: candidateInfo,
            )),
            settings.name);
      }
    } else if (settings.name!.startsWith('/roles')) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(selectedMenuProvider.notifier).state = 3;
      });
      if (settings.name == '/roles') {
        return routing(const Expanded(child: RolesList()), settings.name);
      } else if (settings.name == '/roles/new') {
        return routing(const Expanded(child: AddNewRole()), settings.name);
      }
    } else if (settings.name!.startsWith('/users')) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(selectedMenuProvider.notifier).state = 4;
      });
      if (settings.name == '/users') {
        return routing(const Expanded(child: UsersList()), settings.name);
      } else if (settings.name == '/users/new') {
        return routing(const Expanded(child: InviteNewUser()), settings.name);
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(selectedMenuProvider.notifier).state = 0;
    });
    return routing(const Expanded(child: Homepage()), settings.name);
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
