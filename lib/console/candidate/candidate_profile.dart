import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hireway/custom_fields/builders.dart';
import 'package:hireway/respository/firestore/objects/candidate.dart';
import 'package:hireway/helper/regex_functions.dart';
import 'package:hireway/respository/firestore/objects/round.dart';
import 'package:hireway/respository/firestore/repositories/candidates_repository.dart';
import 'package:hireway/respository/firestore/repositories/rounds_repository.dart';
import 'package:intl/intl.dart';
import 'package:hireway/console/candidate/hire_reject_interview.dart';
import 'package:hireway/custom_fields/highlighted_tag.dart';
import 'package:hireway/respository/firebase/firebase_auth.dart';
import 'package:hireway/helper/stateless_functions.dart';
import 'package:hireway/settings.dart';
import 'package:url_launcher/url_launcher.dart';

class CandidateProfile extends ConsumerStatefulWidget {
  const CandidateProfile({super.key, required this.name, required this.email});

  final String name;
  final String email;

  @override
  ConsumerState<CandidateProfile> createState() => _CandidateProfileState();
}

class _CandidateProfileState extends ConsumerState<CandidateProfile>
    with SingleTickerProviderStateMixin {
  String _latestRoundReview = "";
  double _rating = 0;

  Round? _pendingReviewDocument;

  final CandidatesRepository _candidatesRepository = CandidatesRepository();

  final RoundsRepository _roundsRepository = RoundsRepository();

  final _formKey = GlobalKey<FormState>();
  bool _isFormEnabled = false;

  bool validateAndEnableForm() {
    if (_latestRoundReview.length >= 140) {
      setState(() {
        _isFormEnabled = true;
      });
      return true;
    } else if (_isFormEnabled) {
      setState(() {
        _isFormEnabled = false;
      });
    }
    return false;
  }

  Future<void> validateForm() async {
    if (_latestRoundReview.length < 140 && _isFormEnabled) {
      setState(() {
        _isFormEnabled = false;
      });
    } else if (_formKey.currentState!.validate() && _rating > 0) {
      setState(() {
        _isFormEnabled = true;
      });
    } else if (_isFormEnabled) {
      setState(() {
        _isFormEnabled = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _roundsRepository
        .getAllWhere("candidateInfo", "${widget.name},${widget.email}")
        .then((rounds) {
      setState(() {
        final Iterable<Round> emptyRounds = rounds
            .where((element) => element.interviewer == whoAmI())
            .where((Round element) => element.review.isEmpty);
        _pendingReviewDocument =
            emptyRounds.isNotEmpty ? emptyRounds.first : null;
      });
    });
  }

  Widget ratings(double rating) {
    List<Widget> ratingIcons = [];
    for (int index = 0; index < 5; index++) {
      ratingIcons.add(Icon(
        index + 1 <= rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 30,
      ));
    }
    return Row(
      children: ratingIcons,
    );
  }

  Widget reviewsAndRatings() {
    print("building future for reviews and ratings");
    return withFutureBuilder(
        future: _roundsRepository.getAllWhere(
            "candidateInfo", "${widget.name},${widget.email}"),
        widgetBuilder: roundsListView);
  }

  Widget roundsListView(List<Round> rounds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "All Reviews",
              style: heading2,
            )),
        ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: rounds.length,
            itemBuilder: ((context, index) {
              Round round = rounds[index];
              if (round.review.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      border: round.rating >= 4
                          ? Border.all(color: Colors.green.shade300)
                          : round.rating <= 2
                              ? Border.all(color: Colors.red.shade300)
                              : Border.all(color: Colors.black38)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ratings(round.rating),
                          Text(
                            DateFormat("dd MMMM hh:mm a")
                                .format(DateTime.parse(round.scheduledOn)),
                            style: subHeading,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        round.review,
                        maxLines: 5,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        round.interviewer,
                        style: const TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            })),
      ],
    );
  }

  Widget pendingReviews() {
    return _pendingReviewDocument != null
        ? Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    "Review for interview on ${DateFormat("dd MMMM hh:mm a").format(DateTime.parse(_pendingReviewDocument!.scheduledOn))}",
                    style: heading2,
                  ),
                ),
                RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    maxRating: 5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    }),
                const SizedBox(
                  height: 10,
                ),
                Focus(
                  onFocusChange: (focused) {
                    if (!focused) {
                      validateForm();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: TextFormField(
                      minLines: 5,
                      maxLines: 5,
                      validator: (value) {
                        if (!validateAndEnableForm()) {
                          return 'Please add review of at least 140 characters';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        setState(() {
                          _latestRoundReview = text;
                        });
                        validateAndEnableForm();
                      },
                      decoration: const InputDecoration(
                          hintText:
                              "What did you like or not like about the candidate?"),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: _isFormEnabled
                        ? () async {
                            Round updatedRound = Round(
                                candidateInfo:
                                    _pendingReviewDocument!.candidateInfo,
                                interviewer:
                                    _pendingReviewDocument!.interviewer,
                                rating: _rating,
                                review: _latestRoundReview,
                                scheduledOn:
                                    _pendingReviewDocument!.scheduledOn,
                                uid: _pendingReviewDocument!.uid);
                            await _roundsRepository.update(updatedRound);
                            setState(() {
                              _pendingReviewDocument = null;
                            });
                          }
                        : null,
                    child: const Text("Add this review"))
              ],
            ))
        : Container();
  }

  Widget skillsList(Candidate candidateInfo) {
    List<String> skills = candidateInfo.skills.split(",");
    var skillsWidgets = <Widget>[];
    for (int index = 0; index < skills.length; index++) {
      skillsWidgets.add(highlightedTag(skills[index],
          const TextStyle(color: Colors.black), Colors.grey.shade300));
    }
    return Row(
      children: skillsWidgets,
    );
  }

  Widget candidateInfoWidget(Candidate candidateInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            "Candidate Info",
            style: heading2,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Phone",
                    style: heading3,
                  ),
                ),
                Text(candidateInfo.phone)
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Resume",
                    style: heading3,
                  ),
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 30)),
                    onPressed: () async {
                      final storageRef = FirebaseStorage.instance.ref();
                      String urlPath = await storageRef
                          .child(candidateInfo.resume)
                          .getDownloadURL();
                      final Uri resumeUri = Uri.parse(urlPath);
                      launchUrl(resumeUri);
                    },
                    child: const Text("Download"))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Role",
                    style: heading3,
                  ),
                ),
                Text(candidateInfo.role)
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Skills",
                style: heading3,
              ),
            ),
            skillsList(candidateInfo)
          ],
        )
      ],
    );
  }

  Widget candidateInterviewStage(String interviewStage) {
    switch (interviewStage) {
      case "screening":
        return highlightedTag(interviewStage.toUpperCase(),
            const TextStyle(color: Colors.white), Colors.black54);
      case "ongoing":
        return highlightedTag(interviewStage.toUpperCase(),
            const TextStyle(color: Colors.white), Colors.black54);
      case "hired":
        return highlightedTag(interviewStage.toUpperCase(),
            const TextStyle(color: Colors.white), successColor);
      case "rejected":
        return highlightedTag(interviewStage.toUpperCase(),
            const TextStyle(color: Colors.white), failedColor);
    }
    return highlightedTag(interviewStage.toUpperCase(),
        const TextStyle(color: Colors.white), Colors.black54);
  }

  Widget candidateProfileBuilder(Candidate? candidateInfo) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0, left: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 80.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.name,
                  style: heading1,
                ),
                candidateInterviewStage(candidateInfo!.interviewStage),
              ],
            ),
          ),
          Text(
            widget.email,
            style: subHeading,
          ),
          const SizedBox(
            height: 10,
          ),
          isHired(candidateInfo.interviewStage)
              ? highlightedMessage(
                  "Candidate was hired on ${DateFormat("dd MMMM hh:mm a").format(DateTime.parse(candidateInfo.hiredOrRejectedOn))} by ${getNameFromInfo(candidateInfo.hiringManager)}",
                  const TextStyle(color: Colors.black),
                  Colors.grey.shade300,
                  successColor)
              : Container(),
          isRejected(candidateInfo.interviewStage)
              ? highlightedMessage(
                  "Candidate was rejected on ${DateFormat("dd MMMM hh:mm a").format(DateTime.parse(candidateInfo.hiredOrRejectedOn))} by ${getNameFromInfo(candidateInfo.hiringManager)}",
                  const TextStyle(color: Colors.black),
                  Colors.grey.shade300,
                  failedColor)
              : Container(),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height < 680
                ? MediaQuery.of(context).size.height * 0.6
                : MediaQuery.of(context).size.height * 0.7,
            child: ListView.separated(
              shrinkWrap: false,
              separatorBuilder: (_, __) => const SizedBox(height: 30),
              itemCount: 4,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Padding(
                      padding: const EdgeInsets.only(right: 80.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: candidateInfoWidget(candidateInfo)),
                          const SizedBox(
                            width: 50,
                          ),
                          !isRejected(candidateInfo.interviewStage) &&
                                  !isHired(candidateInfo.interviewStage)
                              ? SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: HireRejectInterview(
                                      name: widget.name,
                                      email: widget.email,
                                      interviewStage:
                                          candidateInfo.interviewStage),
                                )
                              : Container()
                        ],
                      ),
                    );
                  case 1:
                    return Padding(
                      padding: const EdgeInsets.only(right: 80.0),
                      child: pendingReviews(),
                    );
                  case 2:
                    return Padding(
                      padding: const EdgeInsets.only(right: 80.0),
                      child: reviewsAndRatings(),
                    );
                }
                return const SizedBox(
                  height: 30,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return withFutureBuilder(
        future: _candidatesRepository.getOne(widget.email),
        widgetBuilder: candidateProfileBuilder);
  }
}
