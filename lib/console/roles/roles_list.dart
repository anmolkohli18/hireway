import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hireway/console/app_console.dart';
import 'package:hireway/console/enums.dart';
import 'package:hireway/custom_fields/builders.dart';
import 'package:hireway/custom_fields/highlighted_tag.dart';
import 'package:hireway/custom_fields/show_overlay.dart';
import 'package:hireway/respository/firestore/objects/roles.dart';
import 'package:hireway/respository/firestore/repositories/roles_repository.dart';
import 'package:hireway/settings.dart';

class RolesList extends ConsumerStatefulWidget {
  const RolesList({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<RolesList> createState() => _RolesListState();
}

class _RolesListState extends ConsumerState<RolesList>
    with SingleTickerProviderStateMixin {
  int highlightLinkIndex = -1;
  String roleState = "open";

  AnimationController? _animationController;
  Animation<double>? _animation;

  final RolesRepository _rolesRepository = RolesRepository();

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation =
        CurveTween(curve: Curves.fastOutSlowIn).animate(_animationController!);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showOverlay<RolesState>(
          "Role is added successfully!",
          context,
          _animationController,
          _animation,
          rolesStateProvider,
          RolesState.newRoleAdded,
          ref);
      ref.watch(rolesStateProvider.notifier).state = RolesState.rolesList;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget widgetBuilder(List<Role> roles) {
      if (roles.isNotEmpty) {
        return rolesListView(roles);
      } else {
        return overallEmptyState(context);
      }
    }

    // TODO   .orderBy('addedOnDateTime', descending: true)
    return withFutureBuilder(
        future: _rolesRepository.getAll(), widgetBuilder: widgetBuilder);
  }

  Widget rolesListView(List<Role> roles) {
    List<Widget> rolesWidgetList = [];
    for (var index = 0; index < roles.length; index++) {
      Role role = roles[index];
      if (role.state == roleState) {
        rolesWidgetList.add(roleTile(
          index,
          role.title,
          role.description,
          role.state,
          role.skills.split(","),
          role.addedOnDateTime,
        ));
        if (index != roles.length - 1) {
          rolesWidgetList.add(const SizedBox(
            height: 20,
          ));
        }
      }
    }

    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0, right: 80, left: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            const SizedBox(
              height: 32,
            ),
            TabBar(
                onTap: (index) {
                  switch (index) {
                    case 0:
                      setState(() {
                        roleState = "open";
                      });
                      break;
                    case 1:
                      setState(() {
                        roleState = "closed";
                      });
                      break;
                  }
                },
                labelColor: Colors.black,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                tabs: const [
                  Tab(
                    text: "Open Roles",
                  ),
                  Tab(
                    text: "Closed Roles",
                  ),
                ]),
            const SizedBox(
              height: 16,
            ),
            rolesWidgetList.isNotEmpty
                ? Expanded(
                    child: ListView(
                    children: rolesWidgetList,
                  ))
                : tabEmptyState()
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Roles",
              style: heading1,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Manage your open roles",
              style: subHeading,
            ),
          ],
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 60),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: const TextStyle(fontSize: 18),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/roles/new');
            },
            child: Row(
              children: const [
                Icon(Icons.add),
                Text("Add New Role"),
              ],
            ))
      ],
    );
  }

  Widget tabEmptyState() {
    String tabHeading = roleState == "open"
        ? "There are no open roles!"
        : "There are no closed roles!";
    String tabSubHeading = roleState == "open"
        ? "Add open roles now and start hiring."
        : "Whenever all openings of a role are filled, the role will be closed and can be found here.";
    return Expanded(
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              tabHeading,
              style: heading2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 28.0),
            child: Text(
              tabSubHeading,
              style: subHeading,
            ),
          ),
        ]),
      ),
    );
  }

  Widget overallEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0, right: 80, left: 80),
      child: Column(
        children: [
          header(),
          Expanded(
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        "Add open roles to hireway now!",
                        style: heading2,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 28.0),
                      child: Text(
                        "It takes only few seconds to add roles and start hiring.",
                        style: subHeading,
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 60)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/roles/new');
                        },
                        child: const Text(
                          "Add new role",
                          style: TextStyle(fontSize: 16),
                        ))
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget roleTile(int index, String title, String description, String state,
      List<String> skills, String addedOnDateTime) {
    var skillsWidgets = <Widget>[];
    for (int index = 0; index < skills.length && index < 5; index++) {
      skillsWidgets.add(highlightedTag(skills[index],
          const TextStyle(color: Colors.black), Colors.grey.shade300));
    }
    if (skills.length > 5) {
      skillsWidgets.add(highlightedTag(
          "more", const TextStyle(color: Colors.black), Colors.grey.shade300));
    }

    return InkWell(
      onTap: () {},
      onHover: (hovered) {
        if (hovered) {
          setState(() {
            highlightLinkIndex = index;
          });
        } else {
          setState(() {
            highlightLinkIndex = -1;
          });
        }
      },
      child: Card(
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: highlightLinkIndex == index
                            ? const TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.black87,
                                decorationThickness: 2,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 20)
                            : const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        description,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Skills",
                    style: secondaryTextStyle,
                  ),
                  Row(
                    children: skillsWidgets,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
