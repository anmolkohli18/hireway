import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milkyway/settings.dart';
import 'package:milkyway/console/app_console.dart';

class DrawerWidget extends ConsumerWidget {
  final menuItems = [
    ["Home", Icons.home_outlined, '/home'],
    ["Candidates", Icons.person_outline, '/candidates'],
    ["Schedule", Icons.calendar_today_outlined, '/schedule'],
    ["Roles", Icons.computer_outlined, '/roles'],
    ["Interviewers", Icons.computer_outlined, '/interviewers'],
  ];

  DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMenuItem = ref.watch(selectedMenuProvider.state).state;

    var menuListTiles = <Padding>[];

    for (var i = 0; i < menuItems.length; i++) {
      var item = menuItems[i];
      String itemName = item[0] as String;
      IconData iconData = item[1] as IconData;
      String route = item[2] as String;

      menuListTiles.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: i == selectedMenuItem
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: highlightColor)
              : const BoxDecoration(),
          child: ListTile(
            onTap: () {
              ref.read(selectedMenuProvider.notifier).state = i;
              Navigator.pushNamed(context, route);
            },
            leading: Icon(iconData, color: primaryColor, size: 28),
            title: Text(
              itemName,
              style: heading2,
            ),
          ),
        ),
      ));
    }

    return Container(
      width: 300,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 24, bottom: 40.0),
            child: ListTile(
              leading:
                  Icon(Icons.factory_outlined, color: primaryColor, size: 42),
              title: Text(
                "Client Name",
                style: heading1,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: menuListTiles,
            ),
          ),
        ],
      ),
    );
  }
}
