import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milkyway/firebase/candidate/candidates_firestore.dart';

final candidate = candidatesFirestore.where("owner", isEqualTo: "anmol");

class CandidatesStore extends StatelessWidget {
  const CandidatesStore({Key? key}) : super(key: key);

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
                      data.docs[index].data().name,
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
