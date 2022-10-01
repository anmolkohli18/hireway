import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:milkyway/console/app_console.dart';
import 'package:milkyway/console/enums.dart';
import 'package:milkyway/firebase/schedule_firestore.dart';
import 'package:milkyway/helper/regex_functions.dart';
import 'package:milkyway/settings.dart';

class SchedulesList extends ConsumerStatefulWidget {
  const SchedulesList({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SchedulesList> createState() => _SchedulesListState();
}

class _SchedulesListState extends ConsumerState<SchedulesList>
    with SingleTickerProviderStateMixin {
  int highlightLinkIndex = -1;
  String _scheduleState = "today";

  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation =
        CurveTween(curve: Curves.fastOutSlowIn).animate(_animationController!);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _showOverlay("Schedule is added successfully!");
    });
  }

  Widget listOfSchedules(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Schedule>>(
        stream: scheduleFirestore
            .orderBy('startDateTime', descending: false)
            .limit(10)
            .snapshots(),
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
          final List<QueryDocumentSnapshot<Schedule>> schedules =
              snapshot.requireData.docs;
          if (schedules.isNotEmpty) {
            return schedulesListView(schedules);
          } else {
            return overallEmptyState(context);
          }
        });
  }

  Widget schedulesListView(List<QueryDocumentSnapshot<Schedule>> schedules) {
    List<Widget> schedulesWidgetList = [];
    for (var index = 0; index < schedules.length; index++) {
      Schedule schedule = schedules[index].data();
      if (schedule.state == _scheduleState ||
          (_scheduleState == "this_week" &&
              (schedule.state == "today" || schedule.state == "tomorrow"))) {
        schedulesWidgetList.add(scheduleTile(
          index,
          schedule.candidateInfo,
          schedule.interviewers,
          schedule.startDateTime,
          schedule.duration,
          schedule.addedOnDateTime,
        ));
        if (index != schedules.length - 1) {
          schedulesWidgetList.add(const SizedBox(
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
                        _scheduleState = "today";
                      });
                      break;
                    case 1:
                      setState(() {
                        _scheduleState = "tomorrow";
                      });
                      break;
                    case 2:
                      setState(() {
                        _scheduleState = "this_week";
                      });
                      break;
                    case 3:
                      setState(() {
                        _scheduleState = "everything_else";
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
                    text: "Today",
                  ),
                  Tab(
                    text: "Tomorrow",
                  ),
                  Tab(
                    text: "This Week",
                  ),
                  Tab(
                    text: "Everything Else",
                  ),
                ]),
            const SizedBox(
              height: 16,
            ),
            schedulesWidgetList.isNotEmpty
                ? Expanded(
                    child: ListView(
                    children: schedulesWidgetList,
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
              "Schedules",
              style: heading1,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Manage your open schedules",
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
              Navigator.pushNamed(context, '/schedules/new');
            },
            child: Row(
              children: const [
                Icon(Icons.add),
                Text("Add New Schedule"),
              ],
            ))
      ],
    );
  }

  Widget tabEmptyState() {
    String tabHeading;
    String tabSubHeading;
    switch (_scheduleState) {
      case "today":
        tabHeading = "There are no interviews set for today";
        tabSubHeading = "Schedule interviews now and start hiring";
        break;
      case "tomorrow":
        tabHeading = "There are no interviews set for tomorrow";
        tabSubHeading = "Schedule interviews now and start hiring";
        break;
      case "this_week":
        tabHeading = "There are no interviews set for this week";
        tabSubHeading = "Schedule interviews now and start hiring";
        break;
      case "everything_else":
      default:
        tabHeading = "There are no interviews set post this week";
        tabSubHeading = "Schedule interviews now and start hiring";
        break;
    }
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
                        "Schedule the first interview on hireway now!",
                        style: heading2,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 28.0),
                      child: Text(
                        "Now you can manage interview schedule from hireway with a few clicks.",
                        style: subHeading,
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 60)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/schedules/new');
                        },
                        child: const Text(
                          "Pick a time",
                          style: TextStyle(fontSize: 16),
                        ))
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget scheduleTile(int index, String candidateInfo, String interviewers,
      DateTime startDateTime, String duration, String addedOnDateTime) {
    return InkWell(
      // TODO add logic for ontap
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
                  SelectableText(
                    getNameFromInfo(candidateInfo),
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
                  startDateTime.isBefore(DateTime.now())
                      ? highlightedTag("past due", Colors.white, Colors.black45)
                      : Container(),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Interviewers",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        interviewers
                            .split(",")
                            .map((interviewer) => getNameFromInfo(interviewer))
                            .join(", "),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Timing",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${DateFormat("dd MMMM hh:mm a").format(startDateTime)}, $duration",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  )
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

  void _showOverlay(String successText) async {
    if (ref.watch(scheduleStateProvider.state).state !=
        SchedulesState.newScheduleAdded) {
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
    return listOfSchedules(context);
  }
}
