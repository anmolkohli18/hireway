import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milkyway/console/app_console.dart';
import 'package:milkyway/console/enums.dart';
import 'package:milkyway/custom_fields/highlighted_tag.dart';
import 'package:milkyway/firebase/interviewer_firestore.dart';
import 'package:milkyway/settings.dart';

class InterviewersList extends ConsumerStatefulWidget {
  const InterviewersList({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<InterviewersList> createState() => _InterviewersListState();
}

class _InterviewersListState extends ConsumerState<InterviewersList>
    with SingleTickerProviderStateMixin {
  int highlightLinkIndex = -1;
  bool isAvailable = true;

  AnimationController? _animationController;
  Animation<double>? _animation;

  final StreamController<QuerySnapshot<Interviewer>> _streamController =
      StreamController();

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation =
        CurveTween(curve: Curves.fastOutSlowIn).animate(_animationController!);

    _streamController.addStream(interviewerFirestore
        .orderBy('addedOnDateTime', descending: true)
        .limit(10)
        .snapshots());

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _showOverlay("Interviewer is added successfully!");
    });
  }

  Widget listOfInterviewers(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Interviewer>>(
        stream: _streamController.stream,
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
          final List<QueryDocumentSnapshot<Interviewer>> interviewers =
              snapshot.requireData.docs;
          if (interviewers.isNotEmpty) {
            return interviewersListView(interviewers);
          } else {
            return overallEmptyState(context);
          }
        });
  }

  Widget interviewersListView(
      List<QueryDocumentSnapshot<Interviewer>> interviewers) {
    List<Widget> interviewersWidgetList = [];
    for (var index = 0; index < interviewers.length; index++) {
      Interviewer interviewer = interviewers[index].data();
      if (isAvailable == interviewer.available) {
        interviewersWidgetList.add(interviewerTile(
          index,
          interviewer.name,
          interviewer.email,
          interviewer.skills.split(","),
          interviewer.addedOnDateTime,
        ));
        if (index != interviewers.length - 1) {
          interviewersWidgetList.add(const SizedBox(
            height: 20,
          ));
        }
      }
    }

    return DefaultTabController(
      length: 2,
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
                        isAvailable = true;
                      });
                      break;
                    case 1:
                      setState(() {
                        isAvailable = false;
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
                    text: "Available",
                  ),
                  Tab(
                    text: "Not Available",
                  ),
                ]),
            const SizedBox(
              height: 16,
            ),
            interviewersWidgetList.isNotEmpty
                ? Expanded(
                    child: ListView(
                    children: interviewersWidgetList,
                  ))
                : tabEmptyState()
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
              "Interviewers",
              style: heading1,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Manage your available interviewers",
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
              Navigator.pushNamed(context, '/interviewers/new');
            },
            child: Row(
              children: const [
                Icon(Icons.add),
                Text("Add New Interviewer"),
              ],
            ))
      ],
    );
  }

  Widget tabEmptyState() {
    String tabHeading = isAvailable
        ? "There are no available interviewers!"
        : "All interviewers are available!";
    String tabSubHeading = isAvailable
        ? "Add open interviewers now and start hiring."
        : "Interviewers marked as unavailable can be viewed here.";
    return Expanded(
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              tabHeading,
              style: heading2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 28.0),
            child: Text(
              tabSubHeading,
              style: subHeading,
            ),
          ),
        ]),
      ),
    );
  }

  Widget overallEmptyState(BuildContext context) {
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
                        "Add interviewers to hireway now!",
                        style: heading2,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 28.0),
                      child: Text(
                        "It takes only few seconds to add interviewers and start hiring.",
                        style: subHeading,
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 60)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/interviewers/new');
                        },
                        child: const Text(
                          "Add new interviewer",
                          style: TextStyle(fontSize: 16),
                        ))
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget interviewerTile(int index, String name, String email,
      List<String> skills, String addedOnDateTime) {
    var skillsWidgets = <Widget>[];
    for (int index = 0; index < skills.length && index < 5; index++) {
      skillsWidgets.add(highlightedTag(skills[index],
          const TextStyle(color: Colors.black), Colors.grey.shade300));
    }
    if (skills.length > 5) {
      skillsWidgets.add(highlightedTag(
          "more", const TextStyle(color: Colors.black), Colors.grey.shade300));
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
                        email,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Column(
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
            ],
          ),
        ),
      ),
    );
  }

  void _showOverlay(String successText) async {
    if (ref.watch(interviewerStateProvider.state).state !=
        InterviewersState.newInterviewerAdded) {
      return;
    }

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
    return listOfInterviewers(context);
  }
}
