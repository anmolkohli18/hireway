import 'package:flutter/material.dart';
import 'package:milkyway/candidate/resume.dart';
import 'package:milkyway/firebase/candidate/create.dart';
import 'package:milkyway/firebase/auth/firebase_auth.dart';

class CandidateBasicInfo extends StatefulWidget {
  const CandidateBasicInfo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CandidateBasicInfoState();
}

class _CandidateBasicInfoState extends State<CandidateBasicInfo> {
  String fullName = "";
  String role = "";

  final _formKey = GlobalKey<FormState>();

  Future<void> createNewAccount() async {
    if (_formKey.currentState!.validate()) {
      addCandidate(fullName, role);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 448,
          height: 420,
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
                    "Full Name (candidate)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a candidate\'s name';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    setState(() {
                      fullName = text;
                    });
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "e.g. Name of the candidate"),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Role (optional)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onChanged: (text) {
                    setState(() {
                      role = text;
                    });
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "e.g. Role for the candidate"),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Container(
                      height: 40,
                      padding: const EdgeInsets.only(right: 20),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18)))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CandidateResume()));
                          },
                          child: const Text("Next: Upload Resume")),
                    ),
                    SizedBox(
                        height: 40,
                        child: OutlinedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18)))),
                            onPressed: signInUser,
                            child: const Text("Never mind")))
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
