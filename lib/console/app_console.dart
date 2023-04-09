import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hireway/auth/email_page.dart';
import 'package:hireway/auth/password_page.dart';
import 'package:hireway/console/candidate/add_new_candidate.dart';
import 'package:hireway/console/candidate/candidate_profile.dart';
import 'package:hireway/console/candidate/candidates_list.dart';
import 'package:hireway/console/drawer.dart';
import 'package:hireway/console/enums.dart';
import 'package:hireway/console/home/homepage.dart';
import 'package:hireway/console/roles/add_new_roles.dart';
import 'package:hireway/console/roles/roles_list.dart';
import 'package:hireway/console/schedule/add_new_schedule.dart';
import 'package:hireway/console/schedule/schedule_list.dart';
import 'package:hireway/console/users/invite_new_user.dart';
import 'package:hireway/console/users/users_list.dart';

final businessNameProvider = StateProvider((ref) => "");
final selectedMenuProvider = StateProvider((ref) => 0);
final candidatesStateProvider =
    StateProvider((ref) => CandidatesState.candidatesList);
final rolesStateProvider = StateProvider((ref) => RolesState.rolesList);
final userStateProvider = StateProvider((ref) => UsersState.usersList);
final scheduleStateProvider =
    StateProvider((ref) => SchedulesState.schedulesList);

class AppConsole extends ConsumerWidget {
  const AppConsole({super.key, required this.routeSettings});

  final RouteSettings routeSettings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            switch (routeSettings.name) {
              case '/login':
                return const GetEmailForm(
                  isLoginFlow: true,
                );
              case '/signup':
                return const GetEmailForm(
                  isLoginFlow: false,
                );
              default:
                if (routeSettings.name!.startsWith('/signup?email=')) {
                  final String userEmail = routeSettings.name!.split("=")[1];
                  return CreatePasswordForm(
                    email: userEmail,
                    isLoginFlow: false,
                  );
                } else {
                  return const GetEmailForm(
                    isLoginFlow: true,
                  );
                }
            }
          }

          final User? user = snapshot.requireData;
          if (user != null) {
            switch (routeSettings.name) {
              case '/home':
                return wrapScaffoldDrawer(const Homepage());
              case '/candidates':
                return wrapScaffoldDrawer(const CandidatesList());
              case '/candidates/new':
                return wrapScaffoldDrawer(const AddNewCandidate());
              case '/schedules':
                return wrapScaffoldDrawer(const SchedulesList());
              case '/schedules/new':
                final String candidateInfo = routeSettings.arguments != null
                    ? (routeSettings.arguments as Map<String, String>)["info"]!
                    : "";
                return wrapScaffoldDrawer(AddNewSchedule(
                  info: candidateInfo,
                ));
              case '/roles':
                return wrapScaffoldDrawer(const RolesList());
              case '/roles/new':
                return wrapScaffoldDrawer(const AddNewRole());
              case '/users':
                return wrapScaffoldDrawer(const UsersList());
              case '/users/new':
                return wrapScaffoldDrawer(const InviteNewUser());
              default:
                if (routeSettings.name!.startsWith('/candidates?name=')) {
                  final String candidateName = routeSettings.name!
                      .split("=")[1]
                      .split("&")[0]
                      .replaceAll("%20", " ");
                  final String candidateEmail =
                      routeSettings.name!.split("=")[2];
                  return wrapScaffoldDrawer(CandidateProfile(
                    name: candidateName,
                    email: candidateEmail,
                  ));
                } else {
                  return wrapScaffoldDrawer(const Homepage());
                }
            }
          } else {
            return const GetEmailForm(
              isLoginFlow: false,
            );
          }
        }));
  }

  Widget wrapScaffoldDrawer(Widget childWidget) {
    return Scaffold(
      body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [DrawerWidget(), Expanded(child: childWidget)]),
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
