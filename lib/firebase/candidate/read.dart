import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milkyway/firebase/candidate/model.dart';

final candidate = candidates.where("owner", isEqualTo: "anmol");

class Candidates extends StatelessWidget {
  const Candidates({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Candidate>>(
        stream: candidate.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const CircularProgressIndicator(
              color: Colors.white,
            );
          }

          final data = snapshot.requireData;

          return ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      data.docs[index].data().fullName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      data.docs[index].data().resume,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                );
              });
        });
  }
}