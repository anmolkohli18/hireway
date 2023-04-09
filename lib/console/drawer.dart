import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hireway/respository/firebase/firebase_auth.dart';
import 'package:hireway/settings.dart';
import 'package:hireway/console/app_console.dart';

class DrawerWidget extends ConsumerWidget {
  DrawerWidget({Key? key}) : super(key: key);

  final menuItems = [
    ["Home", Icons.home_outlined, '/home'],
    ["Candidates", Icons.person_outline, '/candidates'],
    ["Schedule", Icons.calendar_today_outlined, '/schedules'],
    ["Roles", Icons.computer_outlined, '/roles'],
    ["Users", Icons.person_outline, '/users'],
  ];

  List<Widget> getMenuTiles(BuildContext context, WidgetRef ref) {
    final selectedMenuItem = ref.watch(selectedMenuProvider.state).state;

    List<Widget> menuListTiles = <Widget>[];

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
    return menuListTiles;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuListTiles = getMenuTiles(context, ref);

    return Container(
      width: 300,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 24, bottom: 40.0),
            child: ListTile(
              leading: Icon(
                Icons.new_releases,
                color: successColor,
              ),
              title: Text(
                "Hire Way",
                style: TextStyle(
                    color: successColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: menuListTiles,
            ),
          ),
          Container(
            width: 300,
            height: 100,
            color: highlightColor,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        getCurrentUserName(),
                        style: heading3,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        signOut().then(
                            (value) => Navigator.pushNamed(context, '/login'));
                      },
                    )
                  ],
                ),
                const Divider()
              ],
            ),
          )
        ],
      ),
    );
  }
}
