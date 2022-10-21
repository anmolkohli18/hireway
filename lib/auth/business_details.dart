import 'package:flutter/material.dart';
import 'package:hireway/respository/firebase/firebase_auth.dart';
import 'package:hireway/respository/firestore/firestore_documents.dart';
import 'package:hireway/respository/firestore/objects/hireway_user.dart';
import 'package:hireway/respository/firestore/repositories/users_repository.dart';
import 'package:hireway/settings.dart';
import 'package:intl/intl.dart';

class GetOnboardingDetailsForm extends StatefulWidget {
  const GetOnboardingDetailsForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GetOnboardingDetailsFormState();
}

class _GetOnboardingDetailsFormState extends State<GetOnboardingDetailsForm> {
  String _userName = "";
  String? _userRole;
  String _skills = "";
  String _businessName = "";

  final _formKey = GlobalKey<FormState>();
  final _userNameFieldKey = GlobalKey<FormFieldState>();
  final _userRoleFieldKey = GlobalKey<FormFieldState>();
  final _skillsFieldKey = GlobalKey<FormFieldState>();
  final _businessNameFieldKey = GlobalKey<FormFieldState>();

  bool _isFormEnabled = false;
  double _height = 650;

  final UsersRepository _usersRepository = UsersRepository();

  void validateFormField(GlobalKey<FormFieldState> formFieldKey) {
    if (formFieldKey.currentState!.validate()) {
      validateForm();
    } else {
      validateForm();
      setState(() {
        _height = _height + 18.5;
      });
    }
  }

  Future<void> validateForm() async {
    if (_userName.isNotEmpty &&
        _userRole != null &&
        _skills.isNotEmpty &&
        _businessName.isNotEmpty) {
      setState(() {
        _isFormEnabled = true;
      });
    } else if (_isFormEnabled == true) {
      setState(() {
        _isFormEnabled = false;
      });
    }
  }

  void addClient(String businessName, String userEmail, String userName,
      String userRole, String userSkills) {
    getClientDocument(businessName).set({});

    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String now = dateFormat.format(DateTime.now());

    HirewayUser user = HirewayUser(
        name: userName,
        email: userEmail,
        skills: userSkills,
        userRole: _userRole!,
        available: true,
        businessName: businessName,
        addedOnDateTime: now);
    _usersRepository.insert(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Container(
          width: 600,
          height: _height,
          padding: const EdgeInsets.all(40),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(18))),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text(
                    "We need a few more details to get you started",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Your Name",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextFormField(
                  key: _userNameFieldKey,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    setState(() {
                      _userName = text;
                    });
                    validateFormField(_userNameFieldKey);
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "John David Marcus"),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Your Role",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
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
                  },
                ),
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
                TextFormField(
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
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Business Name",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextFormField(
                  key: _businessNameFieldKey,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name of your business';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    setState(() {
                      _businessName = text;
                    });
                    validateFormField(_businessNameFieldKey);
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Johnsons & Johnsons"),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 50,
                  width: 600,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)))),
                      onPressed: _isFormEnabled
                          ? () {
                              // TODO test with new user, it is throwing null
                              updateDisplayName(_userName);
                              addClient(_businessName, getCurrentUserEmail(),
                                  _userName, _userRole!, _skills);
                              Navigator.pushNamed(context, "/home");
                            }
                          : null,
                      child: const Text(
                        "Go To Homepage",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
