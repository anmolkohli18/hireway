import 'package:flutter/material.dart';
import 'package:milkyway/console/app_console.dart';
import 'package:milkyway/console/drawer.dart';

MyCustomRoute routing(Widget child, String? routeName) {
  return MyCustomRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => Scaffold(
            body: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [DrawerWidget(), child]),
          ));
}
