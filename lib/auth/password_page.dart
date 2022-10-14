import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hireway/auth/business_details.dart';
import 'package:hireway/console/app_console.dart';
import 'package:hireway/console/enums.dart';
import 'package:hireway/respository/firestore/firestore_documents.dart';
import 'package:hireway/settings.dart';
import 'package:hireway/respository/firebase/firebase_auth.dart';

class CreatePasswordForm extends StatefulWidget {
  const CreatePasswordForm(
      {Key? key, required this.email, required this.isLoginFlow})
      : super(key: key);

  final String email;
  final bool isLoginFlow;

  @override
  State<StatefulWidget> createState() => _CreatePasswordFormState();
}

class _CreatePasswordFormState extends State<CreatePasswordForm> {
  String _password = "";

  final _formKey = GlobalKey<FormState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();

  bool _isFormEnabled = false;

  double _height = 320;

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
    if (_password.isNotEmpty) {
      setState(() {
        _isFormEnabled = true;
      });
    } else if (_isFormEnabled) {
      setState(() {
        _isFormEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Container(
          width: 448,
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Text(
                    widget.isLoginFlow
                        ? "Enter your password"
                        : "Create a password",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.w100),
                  ),
                ),
                TextFormField(
                  key: _passwordFieldKey,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    setState(() {
                      _password = text;
                    });
                    validateFormField(_passwordFieldKey);
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter a strong password"),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 368,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)))),
                          onPressed: _isFormEnabled
                              ? () {
                                  createUserAccountOrSignIn(
                                          widget.email, _password)
                                      .then((userAccountState) {
                                    if (userAccountState ==
                                        UserAccountState.accountCreated) {
                                      userDocument(widget.email).get().then(
                                          (DocumentSnapshot<
                                                  Map<String, dynamic>>
                                              value) {
                                        if (value.exists) {
                                          final String userName =
                                              value.data()!["name"];
                                          updateDisplayName(userName).then(
                                              (value) => Navigator.pushNamed(
                                                  context, "/home"));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MyCustomRoute(
                                                  builder: (context) =>
                                                      const GetOnboardingDetailsForm()));
                                        }
                                      });
                                    } else if (userAccountState ==
                                        UserAccountState.signedIn) {
                                      Navigator.pushNamed(context, "/home");
                                    } else if (userAccountState ==
                                        UserAccountState
                                            .unableToCreateAccount) {
                                      print("Unable to create account");
                                    }
                                  });
                                }
                              : null,
                          child: const Text(
                            "Continue",
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
