import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:shpownow/custom_widgets/star_rating_bar.dart';
import 'package:shpownow/services/custom%20classes/review_data.dart';
import 'package:shpownow/services/flutter_services/firestore.dart';

class ReviewCard extends StatefulWidget {
  final String username;
  final double rating;
  final String reviewText;
  final bool showDelete;
  final int index;
  final int id;
  final ReviewData reviewData;

  ReviewCard(
      {required this.username,
      required this.rating,
      required this.reviewText,
      required this.showDelete,
      required this.index,
      required this.id,
      required this.reviewData});

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        //color: Colors.blue,
        border: Border.all(
          width: 3.0,
          color: Colors.grey[400] as Color,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Row(
              children: [
                Icon(
                  Icons.person,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    widget.username,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 17.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.showDelete,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 20.0,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await showModal(
                            configuration: FadeScaleTransitionConfiguration(
                              transitionDuration: Duration(milliseconds: 300),
                            ),
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                title: Text(
                                  'Confirm action',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                content: Text(
                                  'This will delete your review permanently, are you sure you want to proceed?',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Colors.red[600],
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    onPressed: () async {
                                      FirestoreObject firestoreObject =
                                          FirestoreObject();
                                      bool success =
                                          await firestoreObject.deleteReview(
                                              widget.index, widget.id);
                                      if (success) {
                                        Navigator.pop(context);
                                        double newRating = 0;
                                        int newReviewCount = widget.reviewData
                                                .updatedData['review_count'] -
                                            1;
                                        List reviews = widget
                                            .reviewData.updatedData['reviews'];

                                        reviews.removeAt(widget.index);
                                        for (int i = 0;
                                            i < reviews.length;
                                            i++) {
                                          newRating += reviews[i]['rating'] /
                                              newReviewCount;
                                        }

                                        newRating = ((2 * newRating)
                                                .round()
                                                .toDouble()) /
                                            2.0;
                                        widget.reviewData
                                            .updatedData['reviews'] = reviews;
                                        widget.reviewData
                                            .updatedData['rating'] = newRating;
                                        widget.reviewData
                                                .updatedData['review_count'] =
                                            newReviewCount;
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Review deleted',
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ]),
                                        ));
                                      }
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.blue[600],
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          StarRatingBar(
            rating: widget.rating,
            size: 25.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          Flexible(
            child: Text(
              widget.reviewText,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15.0,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
