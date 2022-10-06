import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:hireway/console/app_console.dart';
import 'package:hireway/console/enums.dart';
import 'package:hireway/settings.dart';
import 'package:hireway/firebase/candidates_firestore.dart';
import 'package:hireway/firebase/fire_storage.dart';
import 'package:intl/intl.dart';

class AddNewCandidate extends ConsumerStatefulWidget {
  const AddNewCandidate({Key? key}) : super(key: key);

  @override
  ConsumerState<AddNewCandidate> createState() => _AddNewCandidateState();
}

class _AddNewCandidateState extends ConsumerState<AddNewCandidate> {
  String _name = "";
  String _role = "";
  String _email = "";
  String _phone = "";
  FilePickerResult? _localResumeFile;
  String _skills = ""; // comma-separated

  final _formKey = GlobalKey<FormState>();
  final _nameFieldKey = GlobalKey<FormFieldState>();
  final _roleFieldKey = GlobalKey<FormFieldState>();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _phoneFieldKey = GlobalKey<FormFieldState>();
  final _skillsFieldKey = GlobalKey<FormFieldState>();
  bool _isFormEnabled = false;

  double _height = 680;

  Future<void> addCandidate() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String now = dateFormat.format(DateTime.now());

    Candidate candidate = Candidate(
        name: _name,
        role: _role,
        email: _email,
        phone: _phone,
        resume: 'client-name/$_name/resume.pdf',
        skills: _skills,
        addedOnDateTime: now,
        interviewStage: "screening",
        hiredOrRejectedOn: "");

    uploadFile(candidate.name, _localResumeFile!, candidate.resume)
        .then((resumeFireStorage) {
      if (resumeFireStorage != null) {
        candidatesFirestore
            .doc(candidate.email)
            .set(candidate, SetOptions(merge: true));
        candidatesCollection.doc("metadata").set({
          "candidates":
              FieldValue.arrayUnion(["${candidate.name},${candidate.email}"])
        }, SetOptions(merge: true)).then((value) {
          Navigator.pushNamed(context, '/candidates');
        }).catchError((error) => print("Failed to add candidate $error"));
      }
    });
  }

  Future<void> validateForm() async {
    if (_name.isNotEmpty &&
        _role.isNotEmpty &&
        _email.isNotEmpty &&
        _phone.isNotEmpty &&
        _localResumeFile != null &&
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
                  "Enter candidate details",
                  style: heading1,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Full Name *",
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
                      return 'Please enter candidate\'s name';
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
                  "Role *",
                  style: heading3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: TextFormField(
                  key: _roleFieldKey,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an open role';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    setState(() {
                      _role = text;
                    });
                    validateFormField(_roleFieldKey);
                  },
                  decoration:
                      const InputDecoration(hintText: "Software Engineer"),
                ),
              ),
              parallelEmailPhoneFields(
                  firstWidgetHeading: "Email *",
                  firstErrorMessage: 'Please enter candidate\'s email',
                  firstHintMessage: "john.marcus@gmail.com",
                  secondWidgetHeading: "Phone *",
                  secondErrorMessage: 'Please enter candidate\'s phone number',
                  secondHintMessage: '+1 2222 2222'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 350,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "Resume *",
                            style: heading3,
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(250, 50),
                                      foregroundColor: formDefaultColor,
                                      side:
                                          BorderSide(color: formDefaultColor)),
                                  onPressed: () async {
                                    var selectedFile = await selectFile();
                                    if (selectedFile != null) {
                                      setState(() {
                                        _localResumeFile = selectedFile;
                                      });
                                    }
                                    validateForm();
                                  },
                                  child: const Text("Upload from computer")),
                            ),
                            _localResumeFile != null
                                ? Text(
                                    _localResumeFile!.files.single.name.length >
                                            40
                                        ? _localResumeFile!.files.single.name
                                            .replaceRange(
                                                40,
                                                null,
                                                // _localResumeFile!
                                                //     .files.single.name.length,
                                                "...")
                                        : _localResumeFile!.files.single.name,
                                    style: subHeading,
                                  )
                                : const Text(
                                    "File should be below 5 MB",
                                    style: subHeading,
                                  ),
                          ],
                        )
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
                                  return 'Please enter candidate\'s skills (comma-separated)';
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
                                  hintText: "C++,Java,Flutter"),
                            ),
                          ),
                        ]),
                  )
                ],
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
                                addCandidate().then((value) {
                                  ref
                                      .read(candidatesStateProvider.notifier)
                                      .state = CandidatesState.newCandidateAdded;
                                  Navigator.pushNamed(context, '/candidates');
                                });
                              }
                            : null,
                        child: const Text(
                          "Add this candidate",
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
                        Navigator.pushNamed(context, '/candidates');
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

  Widget parallelEmailPhoneFields(
      {required String firstWidgetHeading,
      required String firstHintMessage,
      required String firstErrorMessage,
      required String secondWidgetHeading,
      required String secondHintMessage,
      required String secondErrorMessage}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  firstWidgetHeading,
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
                        return firstErrorMessage;
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
                    decoration: InputDecoration(hintText: firstHintMessage),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  secondWidgetHeading,
                  style: heading3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: IntlPhoneField(
                  key: _phoneFieldKey,
                  decoration: const InputDecoration(
                    hintText: '2222 2222',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'IN',
                  onChanged: (phone) {
                    setState(() {
                      _phone = phone.completeNumber;
                    });
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
