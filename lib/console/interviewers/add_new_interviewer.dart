import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milkyway/console/app_console.dart';
import 'package:milkyway/console/enums.dart';
import 'package:milkyway/firebase/interviewer_firestore.dart';
import 'package:milkyway/settings.dart';
import 'package:intl/intl.dart';

class AddNewInterviewer extends ConsumerStatefulWidget {
  const AddNewInterviewer({Key? key}) : super(key: key);

  @override
  ConsumerState<AddNewInterviewer> createState() => _AddNewInterviewerState();
}

class _AddNewInterviewerState extends ConsumerState<AddNewInterviewer> {
  String _name = "";
  String _email = "";
  final bool _available = true;
  String _skills = ""; // comma-separated

  final _formKey = GlobalKey<FormState>();
  final _nameFieldKey = GlobalKey<FormFieldState>();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _skillsFieldKey = GlobalKey<FormFieldState>();
  bool _isFormEnabled = false;

  double _height = 540;

  Future<void> addInterviewer() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String now = dateFormat.format(DateTime.now());

    Interviewer interviewer = Interviewer(
        name: _name,
        email: _email,
        available: _available,
        skills: _skills,
        addedOnDateTime: now);

    interviewerFirestore
        .doc(interviewer.name)
        .set(interviewer, SetOptions(merge: true))
        .then((value) => print("Interviewer Added"))
        .catchError((error) => print("Failed to add interviewer $error"))
        .then((value) {
      Navigator.pushNamed(context, '/interviewers');
    });
  }

  Future<void> validateForm() async {
    if (_name.isNotEmpty && _skills.isNotEmpty && _email.isNotEmpty) {
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
                  "Enter Interviewer details",
                  style: heading1,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Interviewer Name *",
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
                      return 'Please enter interviewer\'s name';
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
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              return 'Please enter interviewer\'s email';
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
                  ],
                ),
              ),
              SizedBox(
                width: 350,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                  "Skills that interviewer can test - Java, Database, Design System"),
                        ),
                      ),
                    ]),
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
                                addInterviewer().then((value) {
                                  ref
                                          .read(interviewerStateProvider.notifier)
                                          .state =
                                      InterviewersState.newInterviewerAdded;
                                  Navigator.pushNamed(context, '/interviewers');
                                });
                              }
                            : null,
                        child: const Text(
                          "Add this interviewer",
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
                        Navigator.pushNamed(context, '/interviewers');
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
