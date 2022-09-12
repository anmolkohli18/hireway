import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:milkyway/firebase/auth/firebase_auth.dart';
import 'package:milkyway/firebase/storage/upload.dart';

class CandidateResume extends StatefulWidget {
  final String candidateName;
  final String role;
  const CandidateResume(
      {Key? key, required this.candidateName, required this.role})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CandidateResumeState();
}

class _CandidateResumeState extends State<CandidateResume> {
  String resume = "";
  late Future<FilePickerResult?> filePicked;

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
                        onPressed: () {
                          filePicked =
                              selectFile(widget.candidateName, widget.role);
                        },
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
                          onPressed: () {
                            filePicked.then((filePickerResult) {
                              if (filePickerResult != null) {
                                uploadFile(widget.candidateName, widget.role,
                                    filePickerResult);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CandidateResume(
                                            candidateName: widget.candidateName,
                                            role: widget.role)));
                              } else {
                                print(
                                    "Resume file not found. Please try uploading the file again.");
                              }
                            });
                          },
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
