import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hireway/custom_fields/highlighted_tag.dart';
import 'package:hireway/respository/schedule_firestore.dart';
import 'package:hireway/helper/date_functions.dart';
import 'package:hireway/helper/regex_functions.dart';
import 'package:hireway/settings.dart';
import 'package:intl/intl.dart';

class ScheduleListView extends StatefulWidget {
  const ScheduleListView({super.key, required this.schedules});

  final List<QueryDocumentSnapshot<Schedule>> schedules;

  @override
  State<ScheduleListView> createState() => _ScheduleListViewState();
}

class _ScheduleListViewState extends State<ScheduleListView> {
  int _highlightLinkIndex = -1;
  String _scheduleState = "today";

  bool shouldAddSchedule(Schedule schedule) {
    if (isToday(schedule.startDateTime) && _scheduleState == "today") {
      return true;
    }
    if (isTomorrow(schedule.startDateTime) && _scheduleState == "tomorrow") {
      return true;
    }
    if (schedule.startDateTime.isAfter(DateTime.now()) &&
        _scheduleState == "future") {
      return true;
    }
    if (schedule.startDateTime.isBefore(DateTime.now()) &&
        _scheduleState == "past") {
      return true;
    }
    return false;
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
      case "future":
        tabHeading = "There are no interviews set";
        tabSubHeading = "Schedule interviews now and start hiring";
        break;
      case "past":
      default:
        tabHeading = "There were no interviews in past 2 weeks";
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
            _highlightLinkIndex = index;
          });
        } else {
          setState(() {
            _highlightLinkIndex = -1;
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
                    style: _highlightLinkIndex == index
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
                      ? highlightedTag(
                          "${DateTime.now().day - startDateTime.day} ${DateTime.now().day - startDateTime.day == 1 ? 'day' : 'days'} ago",
                          const TextStyle(color: Colors.white),
                          Colors.black45)
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

  @override
  Widget build(BuildContext context) {
    if (widget.schedules.isNotEmpty) {
      return schedulesListView();
    } else {
      return overallEmptyState(context);
    }
  }

  Widget schedulesListView() {
    List<Widget> schedulesWidgetList = [];
    for (var index = 0; index < widget.schedules.length; index++) {
      Schedule schedule = widget.schedules[index].data();
      if (shouldAddSchedule(schedule)) {
        schedulesWidgetList.add(scheduleTile(
          index,
          schedule.candidateInfo,
          schedule.interviewers,
          schedule.startDateTime,
          schedule.duration,
          schedule.addedOnDateTime,
        ));
        if (index != widget.schedules.length - 1) {
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
                        _scheduleState = "future";
                      });
                      break;
                    case 3:
                      setState(() {
                        _scheduleState = "past";
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
                    text: "All Future",
                  ),
                  Tab(
                    text: "Past (2 weeks)",
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
}
