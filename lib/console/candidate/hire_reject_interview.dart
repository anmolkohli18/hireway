import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hireway/console/app_console.dart';
import 'package:hireway/console/enums.dart';
import 'package:hireway/respository/firebase/firebase_auth.dart';
import 'package:hireway/respository/firestore/objects/candidate.dart';
import 'package:hireway/respository/firestore/repositories/candidates_repository.dart';
import 'package:hireway/settings.dart';

class HireRejectInterview extends ConsumerStatefulWidget {
  const HireRejectInterview(
      {super.key,
      required this.name,
      required this.email,
      required this.interviewStage});

  final String name;
  final String email;
  final String interviewStage;

  @override
  ConsumerState<HireRejectInterview> createState() =>
      _HireRejectInterviewState();
}

class _HireRejectInterviewState extends ConsumerState<HireRejectInterview> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Hiring Manager Section",
                  style: heading2,
                )),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/schedules/new',
                            arguments: {
                              "info": "${widget.name} <${widget.email}>"
                            });
                      },
                      child: const Text("Schedule next round")),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF377C7B)),
                      onPressed: () {
                        AwesomeDialog(
                            context: context,
                            headerAnimationLoop: false,
                            customHeader: const Icon(
                              Icons.add_alert,
                              color: Color(0xFF377C7B),
                              size: 80,
                            ),
                            width: 600,
                            dialogType: DialogType.infoReverse,
                            title: "You are hiring ${widget.name}",
                            titleTextStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            desc:
                                "This is only for internal purpose and No email will be sent to the candidate.",
                            btnOkText: "Hire now!",
                            btnOkColor: const Color(0xFF377C7B),
                            btnOkOnPress: () {
                              final candidatesRepository =
                                  CandidatesRepository();
                              candidatesRepository
                                  .getOne(widget.email)
                                  .then((Candidate? candidate) {
                                Map<String, dynamic> candidateJson =
                                    candidate!.toJson();
                                candidateJson["interviewStage"] = "hired";
                                candidateJson["hiredOrRejectedOn"] =
                                    DateTime.now().toString();
                                candidateJson["hiringManager"] = whoAmI();
                                Candidate newCandidate =
                                    Candidate.fromJson(candidateJson);
                                candidatesRepository.update(newCandidate);
                              });
                              ref.read(candidatesStateProvider.notifier).state =
                                  CandidatesState.candidateHired;
                            }).show();
                      },
                      child: const Text("Hire this candidate")),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          disabledBackgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0XFF565F5F),
                          side: BorderSide(color: Colors.grey.shade100)),
                      onPressed: () {
                        AwesomeDialog(
                            context: context,
                            headerAnimationLoop: false,
                            customHeader: const Icon(
                              Icons.add_alert,
                              color: Color(0XFF565F5F),
                              size: 80,
                            ),
                            width: 600,
                            dialogType: DialogType.infoReverse,
                            title: "You are rejecting ${widget.name}",
                            titleTextStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            desc:
                                "This is only for internal purpose and No email will be sent to the candidate.",
                            btnOkText: "Reject now!",
                            btnOkColor: const Color(0XFF565F5F),
                            btnOkOnPress: () {
                              final candidatesRepository =
                                  CandidatesRepository();
                              candidatesRepository
                                  .getOne(widget.email)
                                  .then((Candidate? candidate) {
                                Map<String, dynamic> candidateJson =
                                    candidate!.toJson();
                                candidateJson["interviewStage"] = "rejected";
                                candidateJson["hiredOrRejectedOn"] =
                                    DateTime.now().toString();
                                candidateJson["hiringManager"] = whoAmI();
                                Candidate newCandidate =
                                    Candidate.fromJson(candidateJson);
                                candidatesRepository.update(newCandidate);
                              });
                              ref.read(candidatesStateProvider.notifier).state =
                                  CandidatesState.candidateRejected;
                            }).show();
                      },
                      child: const Text("Reject this candidate")),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
