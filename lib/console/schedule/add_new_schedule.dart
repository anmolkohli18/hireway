import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hireway/apis/send_calendar_invite.dart';
import 'package:hireway/console/app_console.dart';
import 'package:hireway/console/enums.dart';
import 'package:hireway/custom_fields/auto_complete_multi_text_field.dart';
import 'package:hireway/custom_fields/auto_complete_text_field.dart';
import 'package:hireway/respository/firestore/objects/candidate.dart';
import 'package:hireway/respository/firestore/objects/round.dart';
import 'package:hireway/respository/firestore/objects/schedule.dart';
import 'package:hireway/respository/firestore/repositories/candidates_repository.dart';
import 'package:hireway/respository/firestore/repositories/repository_helper.dart';
import 'package:hireway/respository/firestore/repositories/rounds_repository.dart';
import 'package:hireway/respository/firestore/repositories/schedules_repository.dart';
import 'package:hireway/respository/firestore/repositories/users_repository.dart';
import 'package:hireway/helper/date_functions.dart';
import 'package:hireway/helper/regex_functions.dart';
import 'package:hireway/settings.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddNewSchedule extends ConsumerStatefulWidget {
  const AddNewSchedule({Key? key, required this.info}) : super(key: key);

  final String info;

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

  final SchedulesRepository _schedulesRepository = SchedulesRepository();
  final UsersRepository _usersRepository = UsersRepository();
  final RoundsRepository _roundsRepository = RoundsRepository();

  final List<DropdownMenuItem<String>> _durationDropDown = const [
    DropdownMenuItem<String>(
      value: "15 minutes",
      child: Text("15 minutes"),
    ),
    DropdownMenuItem<String>(
      value: "30 minutes",
      child: Text("30 minutes"),
    ),
    DropdownMenuItem<String>(
      value: "45 minutes",
      child: Text("45 minutes"),
    ),
    DropdownMenuItem<String>(
      value: "60 minutes",
      child: Text("60 minutes"),
    )
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      _candidateInfo = widget.info;
      _height = _height + 28;
    });
  }

  void setCandidate(String candidate) {
    setState(() {
      _candidateInfo = candidate;
      _height = _height + 28;
    });
    validateFormField(_candidateInfoFieldKey);
  }

  void setInterviewers(List<String> interviewers) {
    setState(() {
      _interviewers = interviewers.join("|");
      _height = _height + 28;
    });
    validateFormField(_interviewersFieldKey);
  }

  Future<void> addSchedule() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String now = dateFormat.format(DateTime.now());

    Schedule schedule = Schedule(
        uid: const Uuid().v1(),
        candidateInfo: _candidateInfo,
        interviewers: _interviewers,
        startDateTime: _startDateTime,
        duration: _duration,
        addedOnDateTime: now);

    await _schedulesRepository.insert(schedule);
    String businessName = await getBusinessName();
    await sendCalendarInvite(
        getNameFromInfo(_candidateInfo),
        getEmailFromInfo(_candidateInfo),
        businessName,
        _interviewers.split("|").map((e) => getEmailFromInfo(e)).toList(),
        _startDateTime,
        _startDateTime.add(Duration(minutes: durationInMinutes())));
    _interviewers.split("|").forEach((interviewer) async {
      Round round = Round(
          uid: const Uuid().v1(),
          candidateInfo: schedule.candidateInfo,
          scheduledOn: _startDateTime.toString(),
          interviewer: interviewer,
          rating: 0,
          review: "");
      _roundsRepository.insert(round);
    });

    _updateCandidatesInterviewStage();

    ref.read(scheduleStateProvider.notifier).state =
        SchedulesState.newScheduleAdded;
  }

  int durationInMinutes() {
    switch (_duration) {
      case "15 minutes":
        return 15;
      case "30 minutes":
        return 30;
      case "45 minutes":
        return 45;
      case "60 minutes":
        return 60;
    }
    return 0;
  }

  Future<void> _updateCandidatesInterviewStage() async {
    final emailId = getEmailFromInfo(_candidateInfo);
    final candidatesRepository = CandidatesRepository();
    Candidate? candidate = await candidatesRepository.getOne(emailId);
    Map<String, dynamic> candidateJson = candidate!.toJson();
    candidateJson["interviewStage"] = "ongoing";
    Candidate newCandidate = Candidate.fromJson(candidateJson);
    candidatesRepository.update(newCandidate);
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
                kOptions: CandidatesRepository().candidatesList(),
                onChanged: setCandidate,
                preSelectedOption: _candidateInfo,
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
                kOptions: _usersRepository.usersList(),
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
                            currentValue ?? roundOffMeetingTime()),
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
              DropdownButtonFormField<String>(
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
                        Navigator.pushNamed(context, '/schedules');
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
