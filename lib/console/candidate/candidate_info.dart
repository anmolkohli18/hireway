import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:milkyway/settings.dart';
import 'package:milkyway/firebase/candidate/create.dart';
import 'package:milkyway/firebase/candidate/model.dart';
import 'package:milkyway/firebase/storage/upload.dart';

class CandidateInfo extends StatefulWidget {
  const CandidateInfo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CandidateInfoState();
}

class _CandidateInfoState extends State<CandidateInfo>
    with SingleTickerProviderStateMixin {
  String _fullName = "";
  String role = "";
  FilePickerResult? _filePicked;

  final _formKey = GlobalKey<FormState>();
  bool _isFormEnabled = false;

  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation =
        CurveTween(curve: Curves.fastOutSlowIn).animate(_animationController!);
  }

  Future<void> validateForm() async {
    if (_formKey.currentState!.validate() && _filePicked != null) {
      _isFormEnabled = true;
    } else {
      _isFormEnabled = false;
    }
  }

  void _showOverlay(String successText) async {
    OverlayState? overlayState = Overlay.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    OverlayEntry successOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            left: screenWidth / 2,
            top: 100,
            child: FadeTransition(
              opacity: _animation!,
              child: Card(
                child: Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors
                        .green.shade100, // Color.fromRGBO(165, 214, 167, 1)
                    border: Border.all(color: Colors.green),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.check_box,
                          color: Colors.green.shade600,
                        ),
                        Text(
                          successText,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                        const Icon(
                          Icons.close_outlined,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
    overlayState!.insert(successOverlayEntry);
    _animationController!.forward();
    await Future.delayed(const Duration(seconds: 3))
        .whenComplete(() => _animationController!.reverse())
        .whenComplete(() => successOverlayEntry.remove());
  }

  Future<void> addCandidate() async {
    uploadFile(_fullName, _filePicked!).then((resumePath) {
      if (resumePath != null) {
        addNewCandidate(
            // TODO
            Candidate(
                name: _fullName,
                email: "",
                phone: "",
                role: role,
                resume: resumePath,
                skills: ""));
      }
    }).onError((error, stackTrace) {
      print("Could not upload the file");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 600,
        height: 530,
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
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a candidate\'s name';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    setState(() {
                      _fullName = text;
                    });
                    validateForm();
                  },
                  decoration:
                      const InputDecoration(hintText: "Name of the candidate"),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an open role';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    setState(() {
                      role = text;
                    });
                  },
                  decoration:
                      const InputDecoration(hintText: "Role for the candidate"),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Resume *",
                  style: heading3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              primary: formDefaultColor,
                              side: BorderSide(color: formDefaultColor)),
                          onPressed: () async {
                            var selectedFile = await selectFile();
                            if (selectedFile != null) {
                              setState(() {
                                _filePicked = selectedFile;
                              });
                            }
                            validateForm();
                          },
                          child: const Text("Upload from computer")),
                    ),
                    _filePicked != null
                        ? Text(
                            _filePicked!.files.single.name.replaceRange(40,
                                _filePicked!.files.single.name.length, "..."),
                            style: subHeading,
                          )
                        : const Text(
                            "File should be below 5 MB",
                            style: subHeading,
                          ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    padding: const EdgeInsets.only(right: 20),
                    child: ElevatedButton(
                        onPressed: _isFormEnabled ? addCandidate : null,
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
                        _showOverlay("Candidate is added successfully!");
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
