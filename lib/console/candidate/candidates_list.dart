import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milkyway/console/app_console.dart';
import 'package:milkyway/console/enums.dart';
import 'package:milkyway/firebase/candidates_firestore.dart';
import 'package:milkyway/firebase/rounds_firestore.dart';
import 'package:milkyway/settings.dart';

class CandidatesList extends ConsumerStatefulWidget {
  const CandidatesList({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CandidatesList> createState() => _CandidatesListState();
}

class _CandidatesListState extends ConsumerState<CandidatesList>
    with SingleTickerProviderStateMixin {
  int highlightLinkIndex = -1;
  String interviewStage = "screening";

  AnimationController? _animationController;
  Animation<double>? _animation;

  final StreamController<QuerySnapshot<Candidate>> _candidateStreamController =
      StreamController();

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation =
        CurveTween(curve: Curves.fastOutSlowIn).animate(_animationController!);

    _candidateStreamController.addStream(candidatesFirestore
        .orderBy('addedOnDateTime', descending: true)
        .limit(10)
        .snapshots());

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _showOverlay("Candidate is added successfully!");
    });
  }

  Widget listOfCandidates(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Candidate>>(
        stream: _candidateStreamController.stream,
        builder: (context, snapshot) {
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
          final List<QueryDocumentSnapshot<Candidate>> candidates =
              snapshot.requireData.docs;
          if (candidates.isNotEmpty) {
            return candidatesListView(candidates);
          } else {
            return emptyState(context);
          }
        });
  }

  Widget candidatesListView(List<QueryDocumentSnapshot<Candidate>> candidates) {
    List<Widget> candidatesWidgetList = [];
    for (var index = 0; index < candidates.length; index++) {
      Candidate candidate = candidates[index].data();
      if (candidate.interviewStage == interviewStage) {
        candidatesWidgetList.add(candidateTile(
            index,
            candidate.name,
            candidate.role,
            candidate.email,
            candidate.phone,
            candidate.resume,
            candidate.skills.split(","),
            interviewStage));
        if (index != candidates.length - 1) {
          candidatesWidgetList.add(const SizedBox(
            height: 20,
          ));
        }
      }
    }

    return DefaultTabController(
      length: 4,
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0, right: 80, left: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            const SizedBox(
              height: 32,
            ),
            TabBar(
                onTap: (index) {
                  switch (index) {
                    case 0:
                      setState(() {
                        interviewStage = "screening";
                      });
                      break;
                    case 1:
                      setState(() {
                        interviewStage = "ongoing";
                      });
                      break;
                    case 2:
                      setState(() {
                        interviewStage = "selected";
                      });
                      break;
                    case 3:
                      setState(() {
                        interviewStage = "rejected";
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
            Expanded(
                child: ListView(
              children: candidatesWidgetList,
            ))
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Candidates",
              style: heading1,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Manage your hiring pipeline",
              style: subHeading,
            ),
          ],
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 60),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: primaryButtonColor,
                foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/candidates/new');
            },
            child: Row(
              children: const [
                Icon(Icons.add),
                Text("Add New Candidate"),
              ],
            ))
      ],
    );
  }

  Widget emptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0, right: 80, left: 80),
      child: Column(
        children: [
          header(),
          Expanded(
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 60)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/candidates/new');
                        },
                        child: const Text(
                          "Add new candidate",
                          style: TextStyle(fontSize: 16),
                        ))
                  ]),
            ),
          ),
        ],
      ),
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
      String interviewStage) {
    // TODO get from firestore
    var skillsWidgets = <Widget>[];
    for (int index = 0; index < skills.length && index < 5; index++) {
      skillsWidgets.add(
          highlightedTag(skills[index], Colors.black, Colors.grey.shade300));
    }
    if (skills.length > 5) {
      skillsWidgets
          .add(highlightedTag("more", Colors.black, Colors.grey.shade300));
    }

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/candidates?name=$name&email=$email");
      },
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        role,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      // TODO get average ratings from firebase which is stored using cloud function
                      ratings(4),
                    ],
                  ),
                  latestReviewAndRating(email),
                ],
              ),
              const SizedBox(
                height: 8,
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

  Widget ratings(int rating) {
    List<Widget> ratingIcons = [];
    for (int index = 0; index < 5; index++) {
      ratingIcons.add(Icon(
        index + 1 <= rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 30,
      ));
    }
    return Row(
      children: ratingIcons,
    );
  }

  Widget latestReviewAndRating(String email) {
    final roundsFirestoreInstance = roundsFirestore(email);
    return StreamBuilder<QuerySnapshot<Round>>(
        stream:
            roundsFirestoreInstance.orderBy("scheduledOn").limit(1).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (!snapshot.hasData || snapshot.requireData.docs.isEmpty) {
            return Container();
          }

          Round round = snapshot.requireData.docs[0].data();
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: round.rating >= 4
                    ? Border.all(color: Colors.green.shade300)
                    : round.rating <= 2
                        ? Border.all(color: Colors.red.shade300)
                        : Border.all(color: Colors.black38)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ratings(round.rating),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 400,
                  child: Text(
                    round.review,
                    maxLines: 2,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  round.interviewer,
                  style: const TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w400),
                )
              ],
            ),
          );
        });
  }

  void _showOverlay(String successText) async {
    if (ref.watch(candidatesStateProvider.state).state !=
        CandidatesState.newCandidateAdded) return;

    OverlayState? overlayState = Overlay.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    OverlayEntry successOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            left: screenWidth / 2,
            top: 90,
            child: FadeTransition(
              opacity: _animation!,
              child: Card(
                child: Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors
                        .green.shade100, // Color.fromRGBO(165, 214, 167, 1)
                    border: Border.all(color: Colors.green),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.check_box,
                          color: Colors.green.shade600,
                        ),
                        Text(
                          successText,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                        const Icon(
                          Icons.close_outlined,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
    overlayState!.insert(successOverlayEntry);
    _animationController!.forward();
    await Future.delayed(const Duration(seconds: 3))
        .whenComplete(() => _animationController!.reverse())
        .whenComplete(() => successOverlayEntry.remove());
  }

  @override
  Widget build(BuildContext context) {
    return listOfCandidates(context);
  }
}
