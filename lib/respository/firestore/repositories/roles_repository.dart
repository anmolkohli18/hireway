import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hireway/respository/firestore/firestore_collections.dart';
import 'package:hireway/respository/firestore/firestore_converters.dart';
import 'package:hireway/respository/firestore/firestore_documents.dart';
import 'package:hireway/respository/firestore/objects/roles.dart';
import 'package:hireway/respository/firestore/repositories/repository_helper.dart';
import 'package:hireway/respository/virtual/virtual_db.dart';
import 'package:synchronized/synchronized.dart';

class RolesRepository {
  final VirtualDB _roles = VirtualDB("roles");
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _rolesSubscription;

  bool _subscribed = false;
  final Lock _lock = Lock();

  static final RolesRepository _repo = RolesRepository._privateConstructor();

  RolesRepository._privateConstructor();

  factory RolesRepository() {
    return _repo;
  }

  Future<List<Role>> getAll() async {
    await _repo._subscribe();
    final rolesList = await _roles.list();
    return rolesList.map((item) => Role.fromJson(item)).toList();
  }

  Future<Role?> getOne(String title) async {
    await _repo._subscribe();
    final role = await _roles.findOne("title", title);
    return role.isNotEmpty ? Role.fromJson(role) : null;
  }

  Future<void> insert(Role role) async {
    await _repo._subscribe();
    String businessName = await getBusinessName();
    withRoleDocumentConverter(roleDocument(businessName, role.title)).set(role);
    await _roles.insert(role.toJson());

    roleMetaDocument(businessName).set({
      "roles": FieldValue.arrayUnion([role.title])
    }, SetOptions(merge: true));
  }

  Future<void> update(Role role) async {
    await _repo._subscribe();
    String businessName = await getBusinessName();
    withRoleDocumentConverter(roleDocument(businessName, role.title)).set(role, SetOptions(merge: true));
    await _roles.update(role.toJson(), "title", role.title);
  }

  Future<List<String>> rolesList() async {
    await _repo._subscribe();
    return _roles.getMetadata();
  }

  Future<void> _subscribe() async {
    await _lock.synchronized(() async {
      if (!_subscribed) {
        await _rolesSubscribe();
        _subscribed = true;
      }
    });
  }

  Future<void> _unsubscribe() async {
    _rolesSubscription.cancel();
  }

  Future<void> _rolesSubscribe() async {
    String businessName = await getBusinessName();
    final Stream<QuerySnapshot<Map<String, dynamic>>> roles =
        rolesCollectionRef(businessName).snapshots();
    _rolesSubscription =
        roles.listen((event) => populateVirtualDb(event, _roles, "title"));

    final Stream<DocumentSnapshot<Map<String, dynamic>>> rolesMetadata =
        roleMetaDocument(businessName).snapshots();
    rolesMetadata
        .listen((event) => populateMetadataVirtualDB(event, _roles, "roles"));

    await roles.first;
    await rolesMetadata.first;
  }
}
