import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hireway/respository/firestore/firestore_documents.dart';
import 'package:hireway/respository/firestore/repositories/repository_helper.dart';
import 'package:intl/intl.dart';

class SubscriptionDb {
  Map<String, dynamic>? _subscription;

  Future<void> subscribe() async {
    String businessName = await getBusinessName();
    final DocumentSnapshot<Map<String, dynamic>> subscriptionDocument =
        await getSubscriptionDocument(businessName).get();
    _subscription = subscriptionDocument.data();
  }

  Future<DateTime> subscriptionEndDate() async {
    await subscribe();
    String subscriptionEndDateStr = _subscription!["subscriptionEndDate"];

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.parse(subscriptionEndDateStr);
  }
}
