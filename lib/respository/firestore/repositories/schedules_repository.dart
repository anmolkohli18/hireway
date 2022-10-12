import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hireway/respository/firestore/firestore_collections.dart';
import 'package:hireway/helper/regex_functions.dart';
import 'package:hireway/respository/firestore/firestore_converters.dart';
import 'package:hireway/respository/firestore/firestore_documents.dart';
import 'package:hireway/respository/firestore/objects/schedule.dart';
import 'package:hireway/respository/firestore/repositories/repository_helper.dart';
import 'package:hireway/respository/virtual/virtual_db.dart';
import 'package:synchronized/synchronized.dart';

class SchedulesRepository {
  final VirtualDB _schedules = VirtualDB("schedules");
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _schedulesSubscription;

  bool _subscribed = false;
  final Lock _lock = Lock();

  static final SchedulesRepository _repo =
      SchedulesRepository._privateConstructor();

  SchedulesRepository._privateConstructor();

  factory SchedulesRepository() {
    return _repo;
  }

  Future<List<Schedule>> getAll() async {
    await _repo._subscribe();
    final schedulesList = await _schedules.list();
    return schedulesList.map((item) => Schedule.fromJson(item)).toList();
  }

  Future<Schedule?> getOne(String startDateTime) async {
    await _repo._subscribe();
    final schedule = await _schedules.findOne("startDateTime", startDateTime);
    return schedule.isNotEmpty ? Schedule.fromJson(schedule) : null;
  }

  Future<void> insert(Schedule schedule) async {
    await _repo._subscribe();
    String businessName = await getBusinessName();
    final String candidateEmail = getEmailFromInfo(schedule.candidateInfo);
    withScheduleDocumentConverter(scheduleDocument(
            businessName, candidateEmail, schedule.startDateTime))
        .set(schedule);

    scheduleMetaDocument(businessName).set({
      "schedules": FieldValue.arrayUnion(
          ["$candidateEmail,${schedule.startDateTime.toString()}"])
    }, SetOptions(merge: true));
  }

  Future<void> update(Schedule schedule) async {
    await _repo._subscribe();
    String businessName = await getBusinessName();
    String candidateEmail = getEmailFromInfo(schedule.candidateInfo);
    final schedules = withScheduleDocumentConverter(
        scheduleDocument(businessName, candidateEmail, schedule.startDateTime));
    schedules.set(schedule, SetOptions(merge: true));
  }

  Future<List<String>> schedulesList() async {
    await _repo._subscribe();
    return _schedules.getMetadata();
  }

  Future<void> _subscribe() async {
    await _lock.synchronized(() async {
      if (!_subscribed) {
        await _schedulesSubscribe();
        _subscribed = true;
      }
    });
  }

  Future<void> _unsubscribe() async {
    _schedulesSubscription.cancel();
  }

  Future<void> _schedulesSubscribe() async {
    String businessName = await getBusinessName();
    final Stream<QuerySnapshot<Map<String, dynamic>>> schedules =
        schedulesCollectionRef(businessName).snapshots();
    _schedulesSubscription = schedules.listen(
        (event) => populateVirtualDb(event, _schedules, "candidateInfo"));

    final Stream<DocumentSnapshot<Map<String, dynamic>>> schedulesMetadata =
        scheduleMetaDocument(businessName).snapshots();
    schedulesMetadata.listen(
        (event) => populateMetadataVirtualDB(event, _schedules, "schedules"));

    await schedules.first;
    await schedulesMetadata.first;
  }
}
