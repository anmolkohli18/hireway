import 'dart:async';

class VirtualDB {
  final List<Map<String, dynamic>> _items = [];
  final Map<String, dynamic> _metadata = {};

  static final Map<String, VirtualDB> _db = {
    "candidates": VirtualDB._privateConstructor(),
    "schedules": VirtualDB._privateConstructor(),
    "roles": VirtualDB._privateConstructor(),
    "users": VirtualDB._privateConstructor(),
    "rounds": VirtualDB._privateConstructor()
  };

  VirtualDB._privateConstructor();

  factory VirtualDB(String name) {
    return _db[name]!;
  }

  Future<void> insert(Map<String, dynamic> item) async => _items.add(item);
  Future<void> remove(String key, String value) async =>
      _items.removeWhere((element) => element[key] == value);
  Future<void> update(
          Map<String, dynamic> updatedItem, String key, String value) async =>
      _items[_items.indexWhere((element) => element[key] == value)] =
          updatedItem;
  Future<List<Map<String, dynamic>>> list() async => _items;
  Future<Map<String, dynamic>> findOne(String key, String value) async =>
      _items.firstWhere((element) => element[key] == value,
          orElse: () => <String, dynamic>{});
  Future<bool> exists(String key, String value) async => _items
      .firstWhere((element) => element[key] == value,
          orElse: () => <String, dynamic>{})
      .isNotEmpty;

  Future<List<String>> getMetaList(String key) async =>
      (_metadata[key]! as List<dynamic>).map((e) => e! as String).toList();
  void insertMetadata(Map<String, dynamic> metadata) =>
      _metadata.addAll(metadata);
}
