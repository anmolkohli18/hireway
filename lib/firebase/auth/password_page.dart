import 'package:flutter/material.dart';
import 'package:milkyway/firebase/candidate/create.dart';

class CreatePasswordForm extends StatefulWidget {
  const CreatePasswordForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreatePasswordFormState();
}

class _CreatePasswordFormState extends State<CreatePasswordForm> {
  String name = "";
  String description = "";

  final _formKey = GlobalKey<FormState>();

  Future<void> createNewAccount() async {
    if (_formKey.currentState!.validate()) {
      addCandidate(name, description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                "Create a password",
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
                "Password",
                style: TextStyle(fontWeight: FontWeight.w100),
              ),
            ),
            TextFormField(
              validator: (value) {
                print("Value: $value");
                if (value == null || value.isEmpty) {
                  return 'Please enter an account name';
                }
                return null;
              },
              onChanged: (text) {
                setState(() {
                  name = text;
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)))),
                      onPressed: () {},
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
    );
  }
}
