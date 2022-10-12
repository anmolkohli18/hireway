import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hireway/console/app_console.dart';
import 'package:hireway/console/enums.dart';
import 'package:hireway/respository/roles_firestore.dart';
import 'package:hireway/settings.dart';
import 'package:intl/intl.dart';

class AddNewRole extends ConsumerStatefulWidget {
  const AddNewRole({Key? key}) : super(key: key);

  @override
  ConsumerState<AddNewRole> createState() => _AddNewRoleState();
}

class _AddNewRoleState extends ConsumerState<AddNewRole> {
  String _title = "";
  String _description = "";
  int _openings = 0;
  String _skills = ""; // comma-separated
  final String _state = "open";

  final _formKey = GlobalKey<FormState>();
  final _titleFieldKey = GlobalKey<FormFieldState>();
  final _descriptionFieldKey = GlobalKey<FormFieldState>();
  final _openingsFieldKey = GlobalKey<FormFieldState>();
  final _skillsFieldKey = GlobalKey<FormFieldState>();
  bool _isFormEnabled = false;

  double _height = 680;

  Future<void> addRole() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String now = dateFormat.format(DateTime.now());

    Role role = Role(
        title: _title,
        description: _description,
        openings: _openings,
        state: _state,
        skills: _skills,
        addedOnDateTime: now);

    rolesFirestore
        .doc(role.title)
        .set(role, SetOptions(merge: true))
        .then((value) => print("Role Added"))
        .catchError((error) => print("Failed to add role $error"));
    rolesCollection.doc("metadata").set({
      "roles": FieldValue.arrayUnion([role.title])
    }, SetOptions(merge: true));
  }

  Future<void> validateForm() async {
    if (_title.isNotEmpty &&
        _description.isNotEmpty &&
        _openings != 0 &&
        _state.isNotEmpty &&
        _skills.isNotEmpty) {
      setState(() {
        _isFormEnabled = true;
      });
    } else if (_isFormEnabled == true) {
      setState(() {
        _isFormEnabled = false;
      });
    }
  }

  void validateFormField(GlobalKey<FormFieldState> textFormFieldKey) {
    if (textFormFieldKey.currentState!.validate()) {
      validateForm();
    } else {
      validateForm();
      setState(() {
        _height = _height + 18.5;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 800,
        height: _height,
        padding: const EdgeInsets.all(40),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(18))),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Text(
                  "Enter Role details",
                  style: heading1,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Role Title *",
                  style: heading3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: TextFormField(
                  key: _titleFieldKey,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter role\'s title';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    setState(() {
                      _title = text;
                    });
                    validateFormField(_titleFieldKey);
                  },
                  decoration:
                      const InputDecoration(hintText: "Software Engineer"),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Description *",
                  style: heading3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: TextFormField(
                  key: _descriptionFieldKey,
                  minLines: 8,
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a few lines to describe the role';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    setState(() {
                      _description = text;
                    });
                    validateFormField(_descriptionFieldKey);
                  },
                  decoration: const InputDecoration(
                      hintText:
                          "The role is responsible for payment API development"),
                ),
              ),
              parallelOpeningsSkillsFields(),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    padding: const EdgeInsets.only(right: 20),
                    child: ElevatedButton(
                        onPressed: _isFormEnabled
                            ? () {
                                addRole().then((value) {
                                  ref.read(rolesStateProvider.notifier).state =
                                      RolesState.newRoleAdded;
                                  Navigator.pushNamed(context, '/roles');
                                });
                              }
                            : null,
                        child: const Text(
                          "Add this role",
                        )),
                  ),
                  OutlinedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18)))),
                      onPressed: () {
                        Navigator.pushNamed(context, '/roles');
                      },
                      child: const Text("Never mind"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget parallelOpeningsSkillsFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Openings *",
                  style: heading3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Focus(
                  onFocusChange: (focused) {
                    if (!focused) {
                      validateFormField(_openingsFieldKey);
                    }
                  },
                  child: TextFormField(
                    key: _openingsFieldKey,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    autofocus: false,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.parse(value) == 0) {
                        return 'Please enter number of openings';
                      }
                      return null;
                    },
                    onChanged: (text) {
                      setState(() {
                        _openings = int.parse(text);
                      });
                    },
                    decoration: const InputDecoration(
                        hintText: "How many openings does this role has?"),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 350,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Skills *",
                style: heading3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: TextFormField(
                key: _skillsFieldKey,
                autofocus: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter skills to be tested in interviews (comma-separated)';
                  }
                  return null;
                },
                onChanged: (text) {
                  setState(() {
                    _skills = text;
                  });
                  validateFormField(_skillsFieldKey);
                },
                decoration: const InputDecoration(
                    hintText:
                        "Skills to be tested in the interview - Java, Database, Design System"),
              ),
            ),
          ]),
        )
      ],
    );
  }
}
