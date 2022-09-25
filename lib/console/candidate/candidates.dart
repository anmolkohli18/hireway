import 'package:flutter/material.dart';
import 'package:milkyway/console/candidate/candidate_info.dart';
import 'package:milkyway/console/candidate/candidate_state.dart';
import 'package:milkyway/console/candidate/candidates_list.dart';

class Candidates extends StatefulWidget {
  const Candidates({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CandidatesState();
}

class _CandidatesState extends State<Candidates> {
  CandidatesState _candidatesState = CandidatesState.candidatesList;

  void setCandidatesState(CandidatesState newCandidatesState) {
    print(_candidatesState);
    setState(() {
      _candidatesState = newCandidatesState;
    });
    print(_candidatesState);
  }

  @override
  Widget build(BuildContext context) {
    print("Candidate state = $_candidatesState");
    switch (_candidatesState) {
      case CandidatesState.candidatesList:
        return CandidatesList(
          candidatesStateCallback: setCandidatesState,
        );
      case CandidatesState.newCandidate:
        return CandidateInfo(
          candidatesStateCallback: setCandidatesState,
        );
    }
  }
}
