import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hireway/console/app_console.dart';
import 'package:hireway/console/enums.dart';
import 'package:hireway/firebase/auth/firebase_auth.dart';
import 'package:hireway/firebase/business_user_firestore.dart';
import 'package:hireway/firebase/send_email.dart';
import 'package:hireway/firebase/user_firestore.dart';
import 'package:hireway/settings.dart';
import 'package:intl/intl.dart';

class InviteNewUser extends ConsumerStatefulWidget {
  const InviteNewUser({Key? key}) : super(key: key);

  @override
  ConsumerState<InviteNewUser> createState() => _InviteNewUserState();
}

class _InviteNewUserState extends ConsumerState<InviteNewUser> {
  String _name = "";
  String _email = "";
  String? _userRole;
  final bool _available = true;
  String _skills = ""; // comma-separated

  final _formKey = GlobalKey<FormState>();
  final _nameFieldKey = GlobalKey<FormFieldState>();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _userRoleFieldKey = GlobalKey<FormFieldState>();
  final _skillsFieldKey = GlobalKey<FormFieldState>();
  bool _isFormEnabled = false;

  double _height = 655;

  Future<void> addUser() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String now = dateFormat.format(DateTime.now());

    String businessName = await getBusinessName();
    User user = User(
        name: _name,
        email: _email,
        skills: _skills,
        available: _available,
        businessName: businessName,
        addedOnDateTime: now);

    userFirestore
        .doc(user.email)
        .set(user, SetOptions(merge: true))
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user $error"));
    userMetadata.set({
      "users": FieldValue.arrayUnion(["${user.name},${user.email}"])
    }, SetOptions(merge: true));
  }

  Future<void> validateForm() async {
    if (_name.isNotEmpty &&
        _userRole != null &&
        _skills.isNotEmpty &&
        _email.isNotEmpty) {
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
                  "Enter User details",
                  style: heading1,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "User Name *",
                  style: heading3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: TextFormField(
                  key: _nameFieldKey,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter user\'s name';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    setState(() {
                      _name = text;
                    });
                    validateFormField(_nameFieldKey);
                  },
                  decoration:
                      const InputDecoration(hintText: "John David Marcus"),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Email *",
                  style: heading3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Focus(
                  onFocusChange: (focused) {
                    if (!focused) {
                      validateFormField(_emailFieldKey);
                    }
                  },
                  child: TextFormField(
                    key: _emailFieldKey,
                    autofocus: false,
                    validator: (value) {
                      RegExp emailRegex = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                      if (value == null || value.isEmpty) {
                        return 'Please enter user\'s email';
                      } else if (!emailRegex.hasMatch(_email)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    onChanged: (text) {
                      setState(() {
                        _email = text;
                      });
                    },
                    decoration: const InputDecoration(
                        hintText: "john.marcus@gmail.com"),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  "Role *",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              DropdownButtonFormField<String>(
                  key: _userRoleFieldKey,
                  isExpanded: true,
                  value: _userRole,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a valid role';
                    }
                    return null;
                  },
                  items: const [
                    DropdownMenuItem<String>(
                        value: "Hiring Manager", child: Text("Hiring Manager")),
                    DropdownMenuItem<String>(
                        value: "Interviewer", child: Text("Interviewer")),
                    DropdownMenuItem<String>(value: "HR", child: Text("HR")),
                    DropdownMenuItem<String>(
                        value: "Other", child: Text("Other"))
                  ],
                  onChanged: (selected) {
                    setState(() {
                      _userRole = selected ?? "";
                    });
                    validateFormField(_userRoleFieldKey);
                  }),
              const SizedBox(
                height: 30,
              ),
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
                          "Skills that user can test - Java, Database, Design System"),
                ),
              ),
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
                                addUser().then((value) {
                                  ref.read(userStateProvider.notifier).state =
                                      UsersState.newUserAdded;
                                  Navigator.pushNamed(context, '/users');
                                });

                                const String companyName = "Argoid Analytics";
                                String adminInviter = getUserDetails().name;
                                String inviteeName = _name;
                                String inviteeEmail = _email;
                                sendEmail(
                                    companyName,
                                    adminInviter,
                                    inviteeName,
                                    inviteeEmail,
                                    _userRole!.toLowerCase());
                              }
                            : null,
                        child: const Text(
                          "Add this user",
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
                        Navigator.pushNamed(context, '/users');
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
}
