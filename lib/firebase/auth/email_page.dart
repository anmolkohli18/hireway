import 'package:flutter/material.dart';
import 'package:milkyway/firebase/auth/password_page.dart';
import 'package:milkyway/firebase/candidate/create.dart';

class GetEmailForm extends StatefulWidget {
  const GetEmailForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GetEmailFormState();
}

class _GetEmailFormState extends State<GetEmailForm> {
  String _email = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 448,
          height: 320,
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
                      //color: Colors.white
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.w100),
                  ),
                ),
                TextFormField(
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
                                      borderRadius: BorderRadius.circular(8)))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreatePasswordForm(
                                          email: _email,
                                        )));
                          },
                          child: const Text(
                            "Get started",
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
