import 'package:flutter/material.dart';
import 'package:milkyway/colors.dart';
import 'package:milkyway/console/app_console.dart';
import 'package:milkyway/console/candidate/basic_info.dart';

class CandidatesList extends StatelessWidget {
  const CandidatesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return emptyState(context);
  }

  Widget emptyState(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: Text(
            "Add candidates to hireway now!",
            style: heading2,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 28.0),
          child: Text(
            "It takes only few seconds to add candidates and start interviewing.",
            style: subHeading,
          ),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(200, 60)),
            onPressed: () {
              Navigator.pushNamed(context, '/candidates/new');
            },
            child: const Text(
              "Add new candidate",
              style: TextStyle(fontSize: 16),
            ))
      ]),
    );
  }
}
