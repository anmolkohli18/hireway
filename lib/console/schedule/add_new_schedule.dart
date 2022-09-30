import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:milkyway/console/app_console.dart';
import 'package:milkyway/console/enums.dart';
import 'package:milkyway/custom_fields/auto_complete_text_field.dart';
import 'package:milkyway/firebase/interviewer_firestore.dart';
import 'package:milkyway/firebase/schedule_firestore.dart';
import 'package:milkyway/settings.dart';
import 'package:intl/intl.dart';

class AddNewSchedule extends ConsumerStatefulWidget {
  const AddNewSchedule({Key? key}) : super(key: key);

  @override
  ConsumerState<AddNewSchedule> createState() => _AddNewScheduleState();
}

class _AddNewScheduleState extends ConsumerState<AddNewSchedule> {
  String _candidateName = "";
  String _interviewers = "";
  String _startDateTime = "";
  String _endDateTime = "";

  final _formKey = GlobalKey<FormState>();
  final _candidateNameFieldKey = GlobalKey<FormFieldState>();
  final _interviewersFieldKey = GlobalKey<FormFieldState>();
  final _startDateTimeFieldKey = GlobalKey<FormFieldState>();
  final _endDateTimeFieldKey = GlobalKey<FormFieldState>();
  bool _isFormEnabled = false;

  double _height = 540;

  Future<void> addSchedule() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String now = dateFormat.format(DateTime.now());

    Schedule schedule = Schedule(
        candidateName: _candidateName,
        interviewers: _interviewers,
        startDateTime: _startDateTime,
        endDateTime: _endDateTime,
        addedOnDateTime: now);

    scheduleFirestore
        .doc(schedule.candidateName)
        .set(schedule, SetOptions(merge: true))
        .catchError((error) => print("Failed to add interviewer $error"))
        .then((value) {
      print("Schedule Added");
      Navigator.pushNamed(context, '/schedules');
    });
  }

  Future<void> validateForm() async {
    if (_candidateName.isNotEmpty &&
        _interviewers.isNotEmpty &&
        _startDateTime.isNotEmpty &&
        _endDateTime.isNotEmpty) {
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
                  "Enter Schedule details",
                  style: heading1,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Candidate Name *",
                  style: heading3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: TextFormField(
                  key: _candidateNameFieldKey,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a candidate';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    setState(() {
                      _candidateName = text;
                    });
                    validateFormField(_candidateNameFieldKey);
                  },
                  decoration:
                      const InputDecoration(hintText: "John David Marcus"),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Interviewers (multiple) *",
                  style: heading3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: AutoCompleteTextField(kOptions: interviewersList()),
              ),
              // TODO add date time fields
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
                                addSchedule().then((value) {
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
