import 'package:flutter/material.dart';
import 'package:googleapis/cloudbuild/v1.dart';
import 'package:milkyway/settings.dart';

class CandidatesList extends StatelessWidget {
  const CandidatesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return listOfCandidates(context);
    //return emptyState(context);
  }

  Widget listOfCandidates(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40.0),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          candidateTile(),
          const SizedBox(
            height: 20,
          ),
          candidateTile(),
          const SizedBox(
            height: 20,
          ),
          candidateTile(),
          const SizedBox(
            height: 20,
          ),
          candidateTile(),
          const SizedBox(
            height: 20,
          ),
          candidateTile(),
          const SizedBox(
            height: 20,
          ),
          candidateTile(),
          const SizedBox(
            height: 20,
          ),
          candidateTile(),
          const SizedBox(
            height: 20,
          ),
          candidateTile(),
          const SizedBox(
            height: 20,
          ),
          candidateTile(),
          const SizedBox(
            height: 20,
          ),
          candidateTile(),
          const SizedBox(
            height: 20,
          ),
          candidateTile(),
          const SizedBox(
            height: 20,
          ),
          candidateTile(),
          const SizedBox(
            height: 20,
          ),
          candidateTile(),
          const SizedBox(
            height: 20,
          ),
          candidateTile(),
          const SizedBox(
            height: 20,
          ),
          candidateTile(),
        ],
      ),
    );
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

  Widget candidateTile() {
    // TODO get from firestore
    const String name = "Anmol Kohli";
    const String role = "Software Engineer";
    const String status = "in_progress";
    const List<String> skills = ["C++", "Java", "Flutter"];

    const String email = "anmol@hireway.com";
    const String phone = "+91-9741605152";

    const String resumeLink = "resume_link";

    var skillsWidgets = <Widget>[];
    for (String skill in skills) {
      skillsWidgets.add(highlightedTag(skill, Colors.grey.shade300));
    }

    return Card(
      elevation: 2,
      //collapsedBackgroundColor: Colors.white,
      //backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        name,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const Text(
                        role,
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.star,
                            color: Color(0XFFFDCC0D),
                            size: 30,
                          ),
                          Icon(
                            Icons.star,
                            color: Color(0XFFFDCC0D),
                            size: 30,
                          ),
                          Icon(
                            Icons.star,
                            color: Color(0XFFFDCC0D),
                            size: 30,
                          ),
                          Icon(
                            Icons.star,
                            color: Color(0XFFFDCC0D),
                            size: 30,
                          ),
                          Icon(
                            Icons.star_border,
                            color: Color(0XFFFDCC0D),
                            size: 30,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                candidateStatusTile(status),
              ],
            ),
            const SizedBox(
              height: 18,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Skills",
                        style: secondaryTextStyle,
                      ),
                      Row(
                        children: skillsWidgets,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.email),
                const SizedBox(
                  width: 10,
                ),
                const Icon(Icons.phone),
                const SizedBox(
                  width: 10,
                ),
                const Icon(Icons.download),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget highlightedTag(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          text,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget candidateStatusTile(String candidateStatus) {
    // TODO cover all statuses
    switch (candidateStatus) {
      case "in_progress":
        return highlightedTag("In Progress", Colors.yellow);
      case "selected":
        return highlightedTag("In Progress", Colors.green);
      case "rejected":
        return highlightedTag("In Progress", Colors.redAccent);
    }
    return Container();
  }
}
