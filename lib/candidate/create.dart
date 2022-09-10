import 'package:flutter/material.dart';
import 'package:milkyway/firebase/candidate/create.dart';
import 'package:milkyway/firebase/auth/firebase_auth.dart';
import 'package:milkyway/firebase/storage/upload.dart';

class AddCandidate extends StatefulWidget {
  const AddCandidate({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddCandidateState();
}

class _AddCandidateState extends State<AddCandidate> {
  String fullName = "";
  String resume = "";

  final _formKey = GlobalKey<FormState>();

  Future<void> createNewAccount() async {
    if (_formKey.currentState!.validate()) {
      addCandidate(fullName, resume);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              "Upload resume",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                height: 40,
                child: OutlinedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)))),
                    onPressed: () =>
                        selectAndUploadFile("client-name", fullName),
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18)))),
                      onPressed: createUserAccount,
                      child: const Text("Add this candidate")),
                ),
                SizedBox(
                    height: 40,
                    child: OutlinedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)))),
                        onPressed: signInUser,
                        child: const Text("Never mind")))
              ],
            )
          ],
        ),
      ),
    );
  }
}
