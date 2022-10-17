import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hireway/console/app_console.dart';
import 'package:hireway/console/enums.dart';
import 'package:hireway/console/schedule/schedule_list_view.dart';
import 'package:hireway/custom_fields/builders.dart';
import 'package:hireway/custom_fields/show_overlay.dart';
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
      showOverlay<SchedulesState>(
          "Schedule is added successfully!",
          context,
          _animationController,
          _animation,
          scheduleStateProvider,
          SchedulesState.newScheduleAdded,
          ref);
      ref.watch(scheduleStateProvider.notifier).state =
          SchedulesState.schedulesList;
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
}
