import 'package:flutter/material.dart';
import 'package:milkyway/colors.dart';

class SchedulesList extends StatelessWidget {
  const SchedulesList({Key? key}) : super(key: key);

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
            "Schedule the first interview at hireway now!",
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
            style: ElevatedButton.styleFrom(minimumSize: const Size(200, 60)),
            onPressed: () {},
            child: const Text(
              "Pick a time",
              style: TextStyle(fontSize: 16),
            ))
      ]),
    );
  }
}
