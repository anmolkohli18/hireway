import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/material.dart';
import 'package:hireway/console/home/homepage_report.dart';
import 'package:hireway/respository/firestore/repositories/candidates_repository.dart';
import 'package:hireway/respository/firestore/repositories/roles_repository.dart';
import 'package:hireway/respository/firestore/repositories/schedules_repository.dart';
import 'package:hireway/respository/firestore/repositories/users_repository.dart';
import 'package:hireway/settings.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<StatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final UsersRepository _usersRepository = UsersRepository();
  final RolesRepository _rolesRepository = RolesRepository();
  final CandidatesRepository _candidatesRepository = CandidatesRepository();
  final SchedulesRepository _schedulesRepository = SchedulesRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<String>>>(
        future: Future.wait([
          _rolesRepository.rolesList(),
          _usersRepository.usersList(),
          _candidatesRepository.candidatesList(),
          _schedulesRepository.schedulesList()
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

          final List<List<String>> listOfMetadataList = snapshot.requireData;
          final int rolesCount = listOfMetadataList[0].length;
          final int usersCount = listOfMetadataList[1].length;
          final int candidatesCount = listOfMetadataList[2].length;
          final int schedulesCount = listOfMetadataList[3].length;

          if (rolesCount == 0) {
            return stepsBuilder(currentStep: 1);
          } else if (usersCount == 0) {
            return stepsBuilder(currentStep: 2);
          } else if (candidatesCount == 0) {
            return stepsBuilder(currentStep: 3);
          } else if (schedulesCount == 0) {
            return stepsBuilder(currentStep: 4);
          } else {
            return HomepageReport();
          }
        }));
  }

  Widget stepsBuilder({int currentStep = 1}) {
    return Center(
        child: Container(
            width: 630,
            height: 630,
            padding: const EdgeInsets.all(40),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Finish your hireway setup!",
                          style: heading1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Employers who interview more than 25 candidates are likely to get the best candidate.",
                          style: subHeading,
                        ),
                      ),
                      Text(
                        "Add all your candidates to hireway now.",
                        style: subHeading,
                      ),
                    ],
                  ),
                ),
                EnhanceStepper(
                    currentStep: currentStep,
                    controlsBuilder: (context, controlsDetails) {
                      return Container();
                    },
                    steps: [
                      EnhanceStep(
                        icon: const Icon(Icons.check_circle_outline,
                            color: primaryButtonColor, size: 30),
                        title: Row(
                          children: [
                            Column(
                              children: const [
                                Text(
                                  "Your hireway account is ready!",
                                  style: heading2,
                                ),
                              ],
                            ),
                          ],
                        ),
                        content: const Text(
                          "Start hiring now on Hireway!",
                          style: subHeading,
                        ),
                      ),
                      EnhanceStep(
                          icon: const Icon(Icons.person,
                              color: primaryButtonColor, size: 30),
                          title: Text(
                            "Add an open role",
                            style:
                                currentStep < 1 ? disabledHeading2 : heading2,
                          ),
                          subtitle: const Text(
                            "Start adding open roles to hireway now!",
                            style: subHeading,
                          ),
                          content: Container(
                            alignment: Alignment.topLeft,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/roles/new');
                              },
                              child: const Text("Add Role"),
                            ),
                          )),
                      EnhanceStep(
                          icon: const Icon(Icons.person,
                              color: primaryButtonColor, size: 30),
                          title: Text(
                            "Add your first interviewer",
                            style:
                                currentStep < 2 ? disabledHeading2 : heading2,
                          ),
                          subtitle: const Text(
                            "Start adding interviewers to hireway now!",
                            style: subHeading,
                          ),
                          content: Container(
                            alignment: Alignment.topLeft,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/users/new');
                              },
                              child: const Text("Add Interviewer"),
                            ),
                          )),
                      EnhanceStep(
                          icon: const Icon(Icons.person,
                              color: primaryButtonColor, size: 30),
                          title: Text(
                            "Add your first candidate",
                            style:
                                currentStep < 3 ? disabledHeading2 : heading2,
                          ),
                          subtitle: const Text(
                            "Start adding candidates to hireway now!",
                            style: subHeading,
                          ),
                          content: Container(
                            alignment: Alignment.topLeft,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/candidates/new');
                              },
                              child: const Text("Add Candidate"),
                            ),
                          )),
                      EnhanceStep(
                          icon: const Icon(Icons.calendar_today,
                              color: lightHeadingColor, size: 20),
                          title: Text(
                            "Schedule an interview",
                            style:
                                currentStep < 4 ? disabledHeading2 : heading2,
                          ),
                          subtitle: const Text(
                            "All done! Start scheduling interviews now!",
                            style: subHeading,
                          ),
                          content: Container(
                            alignment: Alignment.topLeft,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/schedules/new');
                              },
                              child: const Text("Add Schedule"),
                            ),
                          )),
                    ]),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    children: const [],
                  ),
                )
              ],
            )));
  }
}
