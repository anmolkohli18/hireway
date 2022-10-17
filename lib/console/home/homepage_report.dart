import 'package:flutter/material.dart';
import 'package:hireway/helper/date_functions.dart';
import 'package:hireway/respository/firestore/objects/candidate.dart';
import 'package:hireway/respository/firestore/objects/hireway_user.dart';
import 'package:hireway/respository/firestore/objects/roles.dart';
import 'package:hireway/respository/firestore/objects/schedule.dart';
import 'package:hireway/respository/firestore/repositories/candidates_repository.dart';
import 'package:hireway/respository/firestore/repositories/roles_repository.dart';
import 'package:hireway/respository/firestore/repositories/schedules_repository.dart';
import 'package:hireway/respository/firestore/repositories/users_repository.dart';
import 'package:hireway/settings.dart';

class HomepageReport extends StatelessWidget {
  HomepageReport({super.key});

  final UsersRepository _usersRepository = UsersRepository();
  final RolesRepository _rolesRepository = RolesRepository();
  final CandidatesRepository _candidatesRepository = CandidatesRepository();
  final SchedulesRepository _schedulesRepository = SchedulesRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<dynamic>>>(
        future: Future.wait([
          _rolesRepository.getAll(),
          _usersRepository.getAll(),
          _candidatesRepository.getAll(),
          _schedulesRepository.getAll()
        ]),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black45,
              ),
            );
          }

          final List<Role> roles = snapshot.data![0] as List<Role>;
          final List<HirewayUser> users =
              snapshot.data![1] as List<HirewayUser>;
          final List<Candidate> candidates =
              snapshot.data![2] as List<Candidate>;
          final List<Schedule> schedules = snapshot.data![3] as List<Schedule>;

          final int screeningCount = candidates
              .where((element) => element.interviewStage == "screening")
              .length;
          final int ongoingCount = candidates
              .where((element) => element.interviewStage == "ongoing")
              .length;
          final int hiredCount = candidates
              .where((element) => element.interviewStage == "hired")
              .length;
          final int rejectedCount = candidates
              .where((element) => element.interviewStage == "rejected")
              .length;

          final int lastMonthInterviews = schedules
              .where((element) => isLastMonth(element.startDateTime))
              .length;
          final int thisMonthInterviews = schedules
              .where((element) => isThisMonth(element.startDateTime))
              .length;
          final int thisWeekInterviews = schedules
              .where((element) => isThisWeek(element.startDateTime))
              .length;
          final int nextWeekInterviews = schedules
              .where((element) => isNextWeek(element.startDateTime))
              .length;

          final int openRoles =
              roles.where((element) => element.state == "open").length;
          final int totalOpenings = roles
              .where((element) => element.state == "open")
              .map((e) => e.openings)
              .reduce((int a, int b) => a + b);

          final int availableInterviewers = users
              .where((element) =>
                  element.userRole == "Interviewer" && element.available)
              .length;
          final int totalInterviewers = users
              .where((element) => element.userRole == "Interviewer")
              .length;

          return Padding(
            padding: const EdgeInsets.only(top: 80.0, right: 80, left: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Homepage",
                  style: heading1,
                ),
                const SizedBox(
                  height: 30,
                ),
                candidatesOverview(
                    screeningCount, ongoingCount, hiredCount, rejectedCount),
                const SizedBox(
                  height: 30,
                ),
                interviewsOverview(lastMonthInterviews, thisMonthInterviews,
                    thisWeekInterviews, nextWeekInterviews),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    rolesOverview(openRoles, totalOpenings),
                    const SizedBox(
                      width: 10,
                    ),
                    interviewersOverview(
                        availableInterviewers, totalInterviewers),
                  ],
                )
              ],
            ),
          );
        }));
  }

  Widget metricCard(String title, String value) {
    return Expanded(
      child: Card(
        elevation: 2,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Column(children: [
            Text(
              title,
              style: heading3,
            ),
            Text(
              value,
              style: heading2,
            )
          ]),
        ),
      ),
    );
  }

  Widget candidatesOverview(
      int screening, int ongoing, int hired, int rejected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Candidates Overview",
          style: heading2,
        ),
        const SizedBox(
          height: 10,
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            metricCard("Screening", screening.toString()),
            metricCard("Ongoing", ongoing.toString()),
            metricCard("Hired", hired.toString()),
            metricCard("Rejected", rejected.toString()),
          ],
        ),
      ],
    );
  }

  Widget interviewsOverview(
      int lastMonth, int thisMonth, int thisWeek, int nextWeek) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Interviews Overview",
          style: heading2,
        ),
        const SizedBox(
          height: 10,
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            metricCard("Last month", lastMonth.toString()),
            metricCard("This month", thisMonth.toString()),
            metricCard("This week", thisWeek.toString()),
            metricCard("Next week", nextWeek.toString()),
          ],
        ),
      ],
    );
  }

  Widget rolesOverview(int openRoles, int totalOpenings) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Roles Overview",
            style: heading2,
          ),
          const SizedBox(
            height: 10,
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              metricCard("Open roles", openRoles.toString()),
              metricCard("Total openings", totalOpenings.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget interviewersOverview(int available, int total) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Interviewers Overview",
            style: heading2,
          ),
          const SizedBox(
            height: 10,
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              metricCard("Available", available.toString()),
              metricCard("Total", total.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
