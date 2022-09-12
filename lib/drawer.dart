import 'package:flutter/material.dart';
import 'package:milkyway/color.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  int selectedItem = 0;

  final menuItems = [
    {"Home", Icons.home_outlined},
    {"Candidates", Icons.person_outline},
    {"Schedule", Icons.calendar_today_outlined}
  ];

  @override
  Widget build(BuildContext context) {
    var menuListTiles = <Padding>[];

    for (var i = 0; i < menuItems.length; i++) {
      var item = menuItems[i];
      String itemName = item.first as String;
      IconData iconData = item.last as IconData;
      menuListTiles.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: i == selectedItem
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: highlightColor)
              : const BoxDecoration(),
          child: ListTile(
            onTap: () {
              setState(() {
                selectedItem = i;
              });
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

    const ListTile(
      leading: Icon(Icons.factory_outlined, color: primaryColor, size: 42),
      title: Text(
        "Client Name",
        style: heading1,
      ),
    );

    return Container(
      width: 240,
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
