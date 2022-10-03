import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:milkyway/firebase/auth/firebase_auth.dart';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0, right: 80, left: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name,
            style: heading1,
          ),
          Text(
            widget.email,
            style: subHeading,
          ),
          const SizedBox(
            height: 30,
          ),
          _pendingReviewDocument != null
              ? Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Review for interview on ${_pendingReviewDocument!.data().scheduledOn}",
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
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          }),
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
              : Container()
        ],
      ),
    );
  }
}
