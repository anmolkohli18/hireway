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

  Future<List<Schedule>> getAll(
      {bool sortByStartDateTime = false, bool descending = false}) async {
    await _repo._subscribe();
    final List<Map<String, dynamic>> schedulesListDB = await _schedules.list();
    final List<Schedule> schedulesList =
        schedulesListDB.map((item) => Schedule.fromJson(item)).toList();
    if (sortByStartDateTime) {
      int compareTo(a, b) => a.startDateTime.compareTo(b.startDateTime);
      schedulesList.sort((Schedule a, Schedule b) =>
          descending ? compareTo(b, a) : compareTo(a, b));
    }
    return schedulesList;
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
    withScheduleDocumentConverter(getScheduleDocument(
            businessName, candidateEmail, schedule.startDateTime))
        .set(schedule);
    await _schedules.insert(schedule.toJson());

    getScheduleMetaDocument(businessName).set({
      "schedules": FieldValue.arrayUnion(
          ["$candidateEmail,${schedule.startDateTime.toString()}"])
    }, SetOptions(merge: true));
  }

  Future<void> update(Schedule schedule) async {
    await _repo._subscribe();
    String businessName = await getBusinessName();
    String candidateEmail = getEmailFromInfo(schedule.candidateInfo);
    withScheduleDocumentConverter(getScheduleDocument(
            businessName, candidateEmail, schedule.startDateTime))
        .set(schedule, SetOptions(merge: true));
    await _schedules.update(schedule.toJson(), "uid", schedule.uid);
  }

  Future<List<String>> schedulesList() async {
    await _repo._subscribe();
    return _schedules.getMetaList("schedules");
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
    _schedulesSubscription = schedules
        .listen((event) => populateVirtualDb(event, _schedules, "uid"));

    final Stream<DocumentSnapshot<Map<String, dynamic>>> schedulesMetadata =
        getScheduleMetaDocument(businessName).snapshots();
    schedulesMetadata
        .listen((event) => populateMetadataVirtualDB(event, _schedules));

    await schedules.first;
    await schedulesMetadata.first;
  }
}
