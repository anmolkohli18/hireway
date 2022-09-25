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
  CandidatesState _prevCandidatesState = CandidatesState.candidatesList;
  CandidatesState _candidatesState = CandidatesState.candidatesList;

  void setCandidatesState(CandidatesState newCandidatesState) {
    setState(() {
      _prevCandidatesState = _candidatesState;
      _candidatesState = newCandidatesState;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_candidatesState) {
      case CandidatesState.candidatesList:
        if (_prevCandidatesState == CandidatesState.newCandidate) {
          // TODO check if candidate was actually added
          return CandidatesList(
            candidatesStateCallback: setCandidatesState,
            showSuccessOverlay: true,
          );
        } else {
          return CandidatesList(
            candidatesStateCallback: setCandidatesState,
            showSuccessOverlay: false,
          );
        }
      case CandidatesState.newCandidate:
        return CandidateInfo(
          candidatesStateCallback: setCandidatesState,
        );
    }
  }
}
