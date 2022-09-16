import 'package:flutter/material.dart';
import 'package:milkyway/firebase/candidate/model.dart';
import 'package:milkyway/settings.dart';

class CandidatesList extends StatefulWidget {
  const CandidatesList({Key? key}) : super(key: key);

  @override
  State<CandidatesList> createState() => _CandidatesListState();
}

class _CandidatesListState extends State<CandidatesList> {
  int highlightLinkIndex = -1;
  String candidateType = "screening";

  Widget listOfCandidates(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0, right: 80, left: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Candidates",
              style: heading1,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Manage your hiring pipeline",
              style: subHeading,
            ),
            const SizedBox(
              height: 32,
            ),
            TabBar(
                onTap: (index) {
                  switch (index) {
                    case 0:
                      setState(() {
                        candidateType = "screening";
                      });
                      break;
                    case 1:
                      setState(() {
                        candidateType = "ongoing";
                      });
                      break;
                    case 2:
                      setState(() {
                        candidateType = "selected";
                      });
                      break;
                    case 3:
                      setState(() {
                        candidateType = "rejected";
                      });
                      break;
                  }
                },
                labelColor: Colors.black,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                tabs: const [
                  Tab(
                    text: "Screening",
                  ),
                  Tab(
                    text: "Ongoing",
                  ),
                  Tab(
                    text: "Selected",
                  ),
                  Tab(
                    text: "Rejected",
                  ),
                ]),
            const SizedBox(
              height: 16,
            ),
            Expanded(child: candidatesListView())
          ],
        ),
      ),
    );
  }

  Widget candidatesListView() {
    List<Candidate> candidates = getCandidates(candidateType);
    List<Widget> candidatesWidgetList = [];
    for (var index = 0; index < candidates.length; index++) {
      Candidate candidate = candidates[index];
      candidatesWidgetList.add(candidateTile(
          index,
          candidate.name,
          candidate.role,
          candidate.email,
          candidate.phone,
          candidate.resume,
          candidate.skills.split(","),
          candidateType));
      if (index != candidates.length - 1) {
        candidatesWidgetList.add(const SizedBox(
          height: 20,
        ));
      }
    }

    return ListView(
      children: candidatesWidgetList,
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

  Widget candidateTile(
      int index,
      String name,
      String role,
      String email,
      String phone,
      String resumeLink,
      List<String> skills,
      String candidateType) {
    // TODO get from firestore
    var skillsWidgets = <Widget>[];
    for (String skill in skills) {
      skillsWidgets
          .add(highlightedTag(skill, Colors.black, Colors.grey.shade300));
    }

    return InkWell(
      onTap: () {},
      onHover: (hovered) {
        if (hovered) {
          setState(() {
            highlightLinkIndex = index;
          });
        } else {
          setState(() {
            highlightLinkIndex = -1;
          });
        }
      },
      child: Card(
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: highlightLinkIndex == index
                        ? const TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black87,
                            decorationThickness: 2,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20)
                        : const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                  ),
                  candidateStatusTile(candidateType),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                role,
                style: const TextStyle(color: Colors.black, fontSize: 16),
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
      ),
    );
  }

  Widget highlightedTag(String text, Color textColor, Color backgroundColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: 100,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  Widget candidateStatusTile(String candidateStatus) {
    // TODO cover all statuses
    switch (candidateStatus) {
      case "screening":
        return highlightedTag(
            "Screening", Colors.white, Colors.orange.shade700);
      case "ongoing":
        return highlightedTag(
            "In Progress", Colors.white, Colors.blue.shade700);
      case "selected":
        return highlightedTag("Selected", Colors.white, Colors.green.shade700);
      case "rejected":
        return highlightedTag("Rejected", Colors.white, Colors.red.shade700);
    }
    return Container();
  }

  List<Candidate> getCandidates(String candidateType) {
    List<Candidate> candidates = [];
    for (var index = 0; index < 10; index++) {
      candidates.add(const Candidate(
          name: "Anmol Kohli",
          role: "Software Engineer",
          email: "anmol@hireway.com",
          phone: "+91-9741605152",
          skills: "C++,Java,Flutter",
          resume: "resume.pdf"));
    }
    return candidates;
  }

  @override
  Widget build(BuildContext context) {
    return listOfCandidates(context);
    //return emptyState(context);
  }
}
