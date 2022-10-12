import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hireway/respository/firestore/firestore_collections.dart';
import 'package:hireway/respository/firestore/firestore_converters.dart';
import 'package:hireway/respository/firestore/firestore_documents.dart';
import 'package:hireway/respository/firestore/objects/hireway_user.dart';
import 'package:hireway/respository/firestore/repositories/repository_helper.dart';
import 'package:hireway/respository/virtual/virtual_db.dart';
import 'package:synchronized/synchronized.dart';

class UsersRepository {
  final VirtualDB _users = VirtualDB("users");
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _usersSubscription;

  bool _subscribed = false;
  final Lock _lock = Lock();

  static final UsersRepository _repo = UsersRepository._privateConstructor();

  UsersRepository._privateConstructor();

  factory UsersRepository() {
    return _repo;
  }

  Future<List<HirewayUser>> getAll() async {
    await _repo._subscribe();
    final usersList = await _users.list();
    return usersList.map((item) => HirewayUser.fromJson(item)).toList();
  }

  Future<HirewayUser?> getOne(String emailId) async {
    await _repo._subscribe();
    final user = await _users.findOne("email", emailId);
    return user.isNotEmpty ? HirewayUser.fromJson(user) : null;
  }

  Future<void> insert(HirewayUser user) async {
    await _repo._subscribe();
    String businessName = await getBusinessName();
    withUserDocumentConverter(userDocument(user.email)).set(user);
    await _users.insert(user.toJson());

    userMetaDocument(businessName).set({
      "users": FieldValue.arrayUnion(["${user.name},${user.email}"])
    }, SetOptions(merge: true));
  }

  Future<void> update(HirewayUser user) async {
    await _repo._subscribe();
    withUserDocumentConverter(userDocument(user.email))
        .set(user, SetOptions(merge: true));
  }

  Future<List<String>> usersList() async {
    await _repo._subscribe();
    return _users.getMetadata();
  }

  Future<void> _subscribe() async {
    await _lock.synchronized(() async {
      if (!_subscribed) {
        await _usersSubscribe();
        _subscribed = true;
      }
    });
  }

  Future<void> _unsubscribe() async {
    _usersSubscription.cancel();
  }

  Future<void> _usersSubscribe() async {
    String businessName = await getBusinessName();
    final Stream<QuerySnapshot<Map<String, dynamic>>> users =
        usersCollectionRef(businessName).snapshots();

    _usersSubscription =
        users.listen((event) => populateVirtualDb(event, _users, "email"));

    final Stream<DocumentSnapshot<Map<String, dynamic>>> usersMetadata =
        userMetaDocument(businessName).snapshots();
    usersMetadata
        .listen((event) => populateMetadataVirtualDB(event, _users, "users"));

    await users.first;
    await usersMetadata.first;
  }
}
