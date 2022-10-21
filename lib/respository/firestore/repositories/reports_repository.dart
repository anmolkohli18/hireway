import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hireway/respository/firestore/firestore_collections.dart';
import 'package:hireway/respository/firestore/firestore_converters.dart';
import 'package:hireway/respository/firestore/firestore_documents.dart';
import 'package:hireway/respository/firestore/objects/report.dart';
import 'package:hireway/respository/firestore/repositories/repository_helper.dart';
import 'package:hireway/respository/virtual/virtual_db.dart';
import 'package:synchronized/synchronized.dart';

class ReportsRepository {
  final VirtualDB _reports = VirtualDB("reports");
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _reportsSubscription;

  bool _subscribed = false;
  final Lock _lock = Lock();

  static final ReportsRepository _repo =
      ReportsRepository._privateConstructor();

  ReportsRepository._privateConstructor();

  factory ReportsRepository() {
    return _repo;
  }

  Future<List<Report>> getAll() async {
    await _repo._subscribe();
    final reportsList = await _reports.list();
    return reportsList.map((item) => Report.fromJson(item)).toList();
  }

  Future<Report?> getOne(String reportId) async {
    await _repo._subscribe();
    final report = await _reports.findOne("reportId", reportId);
    return report.isNotEmpty ? Report.fromJson(report) : null;
  }

  Future<void> insert(Report report) async {
    await _repo._subscribe();
    String businessName = await getBusinessName();
    withReportDocumentConverter(
            getReportDocument(businessName, report.reportId))
        .set(report);
    await _reports.insert(report.toJson());

    getReportMetaDocument(businessName).set({
      "reports": FieldValue.arrayUnion([report.reportId])
    }, SetOptions(merge: true));
  }

  Future<void> update(Report report) async {
    await _repo._subscribe();
    String businessName = await getBusinessName();
    withReportDocumentConverter(
            getReportDocument(businessName, report.reportId))
        .set(report, SetOptions(merge: true));
    await _reports.update(report.toJson(), "reportId", report.reportId);
  }

  Future<List<String>> reportsList() async {
    await _repo._subscribe();
    return _reports.getMetaList("reports");
  }

  Future<void> _subscribe() async {
    await _lock.synchronized(() async {
      if (!_subscribed) {
        await _reportsSubscribe();
        _subscribed = true;
      }
    });
  }

  Future<void> _unsubscribe() async {
    _reportsSubscription.cancel();
  }

  Future<void> _reportsSubscribe() async {
    String businessName = await getBusinessName();
    final Stream<QuerySnapshot<Map<String, dynamic>>> reports =
        reportsCollectionRef(businessName).snapshots();
    _reportsSubscription = reports
        .listen((event) => populateVirtualDb(event, _reports, "reportId"));

    final Stream<DocumentSnapshot<Map<String, dynamic>>> reportsMetadata =
        getReportMetaDocument(businessName).snapshots();
    reportsMetadata
        .listen((event) => populateMetadataVirtualDB(event, _reports));

    await reports.first;
    await reportsMetadata.first;
  }
}
