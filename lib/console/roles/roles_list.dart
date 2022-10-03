import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milkyway/console/app_console.dart';
import 'package:milkyway/console/enums.dart';
import 'package:milkyway/firebase/roles_firestore.dart';
import 'package:milkyway/settings.dart';

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

  final StreamController<QuerySnapshot<Role>> _streamController =
      StreamController();

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation =
        CurveTween(curve: Curves.fastOutSlowIn).animate(_animationController!);

    _streamController.addStream(rolesFirestore
        .orderBy('addedOnDateTime', descending: true)
        .limit(10)
        .snapshots());

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _showOverlay("Role is added successfully!");
    });
  }

  Widget listOfRoles(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Role>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black45,
              ),
            );
          }
          final List<QueryDocumentSnapshot<Role>> roles =
              snapshot.requireData.docs;
          if (roles.isNotEmpty) {
            return rolesListView(roles);
          } else {
            return overallEmptyState(context);
          }
        });
  }

  Widget rolesListView(List<QueryDocumentSnapshot<Role>> roles) {
    List<Widget> rolesWidgetList = [];
    for (var index = 0; index < roles.length; index++) {
      Role role = roles[index].data();
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
                backgroundColor: primaryButtonColor,
                foregroundColor: Colors.white),
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
      skillsWidgets.add(
          highlightedTag(skills[index], Colors.black, Colors.grey.shade300));
    }
    if (skills.length > 5) {
      skillsWidgets
          .add(highlightedTag("more", Colors.black, Colors.grey.shade300));
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

  Widget highlightedTag(String text, Color textColor, Color backgroundColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  void _showOverlay(String successText) async {
    if (ref.watch(rolesStateProvider.state).state != RolesState.newRoleAdded) {
      return;
    }

    OverlayState? overlayState = Overlay.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    OverlayEntry successOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            left: screenWidth / 2,
            top: 90,
            child: FadeTransition(
              opacity: _animation!,
              child: Card(
                child: Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors
                        .green.shade100, // Color.fromRGBO(165, 214, 167, 1)
                    border: Border.all(color: Colors.green),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.check_box,
                          color: Colors.green.shade600,
                        ),
                        Text(
                          successText,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                        const Icon(
                          Icons.close_outlined,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
    overlayState!.insert(successOverlayEntry);
    _animationController!.forward();
    await Future.delayed(const Duration(seconds: 3))
        .whenComplete(() => _animationController!.reverse())
        .whenComplete(() => successOverlayEntry.remove());
  }

  @override
  Widget build(BuildContext context) {
    return listOfRoles(context);
  }
}
