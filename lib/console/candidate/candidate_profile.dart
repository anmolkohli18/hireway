import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:milkyway/custom_fields/highlighted_tag.dart';
import 'package:milkyway/firebase/auth/firebase_auth.dart';
import 'package:milkyway/firebase/candidates_firestore.dart';
import 'package:milkyway/firebase/rounds_firestore.dart';
import 'package:milkyway/settings.dart';

class CandidateProfile extends StatefulWidget {
  const CandidateProfile({super.key, required this.name, required this.email});

  final String name;
  final String email;

  @override
  State<CandidateProfile> createState() => _CandidateProfileState();
}

class _CandidateProfileState extends State<CandidateProfile> {
  String _latestRoundReview = "";
  double _rating = 0;

  QueryDocumentSnapshot<Round>? _pendingReviewDocument;
  Candidate? _candidateInfo;

  final StreamController<QuerySnapshot<Round>> _streamController =
      StreamController();

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
    candidatesFirestore
        .where("email", isEqualTo: widget.email)
        .get()
        .then((value) {
      setState(() {
        _candidateInfo = value.docs.first.data();
      });
    });

    _streamController.addStream(roundsFirestore(widget.email)
        .orderBy("scheduledOn", descending: true)
        .limit(10)
        .snapshots());

    roundsFirestore(widget.email)
        .where("interviewer", isEqualTo: whoAmI())
        .where("review", isEqualTo: "")
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        setState(() {
          _pendingReviewDocument = value.docs.first;
        });
      }
    });
  }

  Widget ratings(int rating) {
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

  Widget reviewsAndRatings(String email) {
    return StreamBuilder<QuerySnapshot<Round>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (!snapshot.hasData || snapshot.requireData.docs.isEmpty) {
            return Container();
          }

          final rounds = snapshot.requireData.docs;
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
                    Round round = rounds[index].data();
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
                                  DateFormat("dd MMMM hh:mm a").format(
                                      DateTime.parse(round.scheduledOn)),
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
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              round.interviewer,
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400),
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
        });
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
                    "Review for interview on ${DateFormat("dd MMMM hh:mm a").format(DateTime.parse(_pendingReviewDocument!.data().scheduledOn))}",
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
                        ? () {
                            // TODO add rating field and update rating below
                            roundsFirestore(widget.email)
                                .doc(_pendingReviewDocument!.id)
                                .update({
                              "rating": _rating,
                              "review": _latestRoundReview
                            });
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

  Widget skillsList() {
    List<String> skills = _candidateInfo!.skills.split(",");
    var skillsWidgets = <Widget>[];
    for (int index = 0; index < skills.length; index++) {
      skillsWidgets.add(
          highlightedTag(skills[index], Colors.black, Colors.grey.shade300));
    }
    return Row(
      children: skillsWidgets,
    );
  }

  Widget candidateInfoWidget() {
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
        _candidateInfo != null
            ? Row(
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
                      Text(_candidateInfo!.phone)
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
                          onPressed: () {
                            print(_candidateInfo!.resume);
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
                      Text(_candidateInfo!.role)
                    ],
                  ),
                ],
              )
            : Container(),
        const SizedBox(
          height: 10,
        ),
        _candidateInfo != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Skills",
                      style: heading3,
                    ),
                  ),
                  skillsList()
                ],
              )
            : Container()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0, left: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.name,
                style: heading1,
              ),
              _candidateInfo != null
                  ? highlightedTag(_candidateInfo!.interviewStage, Colors.white,
                      Colors.black54)
                  : Container(),
            ],
          ),
          Text(
            widget.email,
            style: subHeading,
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: ListView.separated(
              shrinkWrap: false,
              separatorBuilder: (_, __) => const SizedBox(height: 30),
              itemCount: 3,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 80.0),
                    child: candidateInfoWidget(),
                  );
                }
                if (index == 1) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 80.0),
                    child: pendingReviews(),
                  );
                }
                if (index == 2) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 80.0),
                    child: reviewsAndRatings(widget.email),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
