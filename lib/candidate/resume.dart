import 'package:flutter/material.dart';
import 'package:milkyway/firebase/auth/firebase_auth.dart';
import 'package:milkyway/firebase/storage/upload.dart';

class CandidateResume extends StatefulWidget {
  const CandidateResume({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CandidateResumeState();
}

class _CandidateResumeState extends State<CandidateResume> {
  String resume = "";

  final _formKey = GlobalKey<FormState>();

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
                const Text(
                  "Resume",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    height: 40,
                    child: OutlinedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)))),
                        onPressed: () => selectAndUploadFile(
                            "client-name", "candidate-name"),
                        child: const Text("Upload from computer"))),
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
                          onPressed: () {},
                          child: const Text("Add this candidate")),
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
