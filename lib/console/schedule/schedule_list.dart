import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hireway/console/app_console.dart';
import 'package:hireway/console/enums.dart';
import 'package:hireway/console/schedule/schedule_list_view.dart';
import 'package:hireway/custom_fields/builders.dart';
import 'package:hireway/respository/firestore/objects/schedule.dart';
import 'package:hireway/respository/firestore/repositories/schedules_repository.dart';

class SchedulesList extends ConsumerStatefulWidget {
  const SchedulesList({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SchedulesList> createState() => _SchedulesListState();
}

class _SchedulesListState extends ConsumerState<SchedulesList>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;

  final SchedulesRepository _schedulesRepository = SchedulesRepository();

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

  @override
  Widget build(BuildContext context) {
    Widget widgetBuilder(List<Schedule> schedules) {
      return ScheduleListView(schedules: schedules);
    }

    // TODO    .orderBy('startDateTime', descending: false)
    return withFutureBuilder(
        future: _schedulesRepository.getAll(), widgetBuilder: widgetBuilder);
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
}
