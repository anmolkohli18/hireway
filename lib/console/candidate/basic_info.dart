import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:milkyway/colors.dart';
import 'package:milkyway/console/candidate/resume.dart';
import 'package:milkyway/console/routes/routing.dart';
import 'package:milkyway/firebase/candidate/create.dart';
import 'package:milkyway/firebase/auth/firebase_auth.dart';
import 'package:milkyway/firebase/storage/upload.dart';

class CandidateBasicInfo extends StatefulWidget {
  const CandidateBasicInfo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CandidateBasicInfoState();
}

class _CandidateBasicInfoState extends State<CandidateBasicInfo> {
  String fullName = "";
  String role = "";
  late Future<FilePickerResult?> filePicked;

  final _formKey = GlobalKey<FormState>();

  Future<void> createNewAccount() async {
    if (_formKey.currentState!.validate()) {
      addCandidate(fullName, role);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 548,
        height: 520,
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
                  "Full Name",
                  style: heading3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: TextFormField(
                  autofocus: true,
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
                      hintText: "e.g. Name of the candidate"),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Role (optional)",
                  style: heading3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: TextFormField(
                  onChanged: (text) {
                    setState(() {
                      role = text;
                    });
                  },
                  decoration: const InputDecoration(
                      hintText: "e.g. Role for the candidate"),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Resume",
                  style: heading3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        primary: formDefaultColor,
                        side: BorderSide(color: formDefaultColor)),
                    onPressed: () {
                      filePicked = selectFile();
                    },
                    child: const Text("Upload from computer")),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    padding: const EdgeInsets.only(right: 20),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)))),
                        onPressed: () {
                          addCandidate(fullName, role);
                          Navigator.push(
                              context,
                              routing(
                                  Expanded(
                                      // TODO change to success page
                                      child: CandidateResume(
                                          candidateName: fullName, role: role)),
                                  '/candidates/new'));
                        },
                        child: const Text("Next: Upload Resume")),
                  ),
                  OutlinedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18)))),
                      onPressed: () {
                        Navigator.pop(context);
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
