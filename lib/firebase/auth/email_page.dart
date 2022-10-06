import 'package:flutter/material.dart';
import 'package:hireway/settings.dart';
import 'package:hireway/console/app_console.dart';
import 'package:hireway/firebase/auth/password_page.dart';

class GetEmailForm extends StatefulWidget {
  const GetEmailForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GetEmailFormState();
}

class _GetEmailFormState extends State<GetEmailForm> {
  String _email = "";

  final _formKey = GlobalKey<FormState>();
  final _emailFieldKey = GlobalKey<FormFieldState>();

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
    if (_email.isNotEmpty) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
                    const Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Text(
                        "Try Milkyway free for 30 days",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Email address",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextFormField(
                      key: _emailFieldKey,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid email id';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        setState(() {
                          _email = text;
                        });
                        validateFormField(_emailFieldKey);
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "john.doe@example.com"),
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
                                          borderRadius:
                                              BorderRadius.circular(8)))),
                              onPressed: _isFormEnabled
                                  ? () {
                                      Navigator.push(
                                          context,
                                          MyCustomRoute(
                                              builder: (context) =>
                                                  CreatePasswordForm(
                                                    email: _email,
                                                  )));
                                    }
                                  : null,
                              child: const Text(
                                "Get started",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Already a member?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white)),
                TextButton(
                  child: const Text("Log In",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          color: Colors.white)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
