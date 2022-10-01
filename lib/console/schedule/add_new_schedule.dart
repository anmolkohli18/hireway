import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milkyway/console/app_console.dart';
import 'package:milkyway/console/enums.dart';
import 'package:milkyway/custom_fields/auto_complete_multi_text_field.dart';
import 'package:milkyway/custom_fields/auto_complete_text_field.dart';
import 'package:milkyway/firebase/candidates_firestore.dart';
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
  String _candidateInfo = "";
  String _interviewers = "";
  DateTime _startDateTime = DateTime.now();
  String _duration = "30 minutes";

  final _formKey = GlobalKey<FormState>();
  final _candidateInfoFieldKey = GlobalKey<FormFieldState>();
  final _interviewersFieldKey = GlobalKey<FormFieldState>();
  final _startDateTimeFieldKey = GlobalKey<FormFieldState>();
  final _durationFieldKey = GlobalKey<FormFieldState>();
  bool _isFormEnabled = false;

  double _height = 620;

  final _durationDropDown = [
    const DropdownMenuItem<String>(
      value: "15 minutes",
      child: Text("15 minutes"),
    ),
    const DropdownMenuItem<String>(
      value: "30 minutes",
      child: Text("30 minutes"),
    ),
    const DropdownMenuItem<String>(
      value: "45 minutes",
      child: Text("45 minutes"),
    ),
    const DropdownMenuItem<String>(
      value: "60 minutes",
      child: Text("60 minutes"),
    )
  ];

  void setCandidate(String candidate) {
    setState(() {
      _candidateInfo = candidate;
      _height = _height + 28;
    });
    validateFormField(_candidateInfoFieldKey);
  }

  void setInterviewers(List<String> interviewers) {
    setState(() {
      _interviewers = interviewers.join(",");
      _height = _height + 28;
    });
    validateFormField(_interviewersFieldKey);
  }

  Future<void> addSchedule() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String now = dateFormat.format(DateTime.now());

    Schedule schedule =
        Schedule(_candidateInfo, _interviewers, _startDateTime, _duration, now);

    final regex = RegExp(
        r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    RegExpMatch? match = regex.firstMatch(schedule.candidateInfo);
    String candidateEmail = match != null
        ? schedule.candidateInfo.substring(match.start, match.end)
        : "Candidate Email Not Found";

    scheduleFirestore
        .doc(candidateEmail)
        .set(schedule, SetOptions(merge: true))
        .catchError((error) => print("Failed to add interviewer $error"))
        .then((value) {
      print("Schedule Added");
      Navigator.pushNamed(context, '/schedules');
    });
  }

  Future<void> validateForm() async {
    if (_candidateInfo.isNotEmpty &&
        _interviewers.isNotEmpty &&
        _startDateTime.isAfter(DateTime.now()) &&
        _duration.isNotEmpty) {
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
                  "Enter Interview details",
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
              AutoCompleteTextField(
                textFieldKey: _candidateInfoFieldKey,
                kOptions: candidatesList(),
                onChanged: setCandidate,
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Interviewers (multiple) *",
                  style: heading3,
                ),
              ),
              AutoCompleteMultiTextField(
                textFieldKey: _interviewersFieldKey,
                kOptions: interviewersList(),
                onChanged: setInterviewers,
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Interview Time *",
                  style: heading3,
                ),
              ),
              DateTimeField(
                  key: _startDateTimeFieldKey,
                  onChanged: (date) {
                    setState(() {
                      _startDateTime = date!;
                    });
                    validateForm();
                  },
                  format: DateFormat("dd MMMM yyyy hh:mm a"),
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: currentValue ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Colors.black,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    Colors.black, // button text color
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Colors.black,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Colors.black, // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  }),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Interview Duration *",
                  style: heading3,
                ),
              ),
              DropdownButton<String>(
                  key: _durationFieldKey,
                  isExpanded: true,
                  value: _duration,
                  items: _durationDropDown,
                  onChanged: (duration) {
                    setState(() {
                      _duration = duration!;
                    });
                    validateForm();
                  }),
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
                                      .read(scheduleStateProvider.notifier)
                                      .state = SchedulesState.newScheduleAdded;
                                  Navigator.pushNamed(context, '/schedules');
                                });
                              }
                            : null,
                        child: const Text(
                          "Add this interview",
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
