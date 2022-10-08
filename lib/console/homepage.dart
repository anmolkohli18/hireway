import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/material.dart';
import 'package:hireway/settings.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            width: 648,
            height: 520,
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
                    currentStep: 1,
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
                          title: const Text(
                            "Add your first candidate",
                            style: heading2,
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
                      const EnhanceStep(
                          icon: Icon(Icons.calendar_today,
                              color: lightHeadingColor, size: 20),
                          title: Text(
                            "Set up interviews",
                            style: disabledHeading2,
                          ),
                          content: Text(
                            "All done! Start scheduling interviews now!",
                            style: heading2,
                          ))
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
