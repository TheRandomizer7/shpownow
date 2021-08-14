import 'package:flutter/material.dart';
import 'package:shpownow/custom_widgets/star_rating_bar.dart';
import 'package:shpownow/pages/product.dart';
import 'package:shpownow/services/flutter_services/firestore.dart';

class ReviewCard extends StatefulWidget {
  final String username;
  final double rating;
  final String reviewText;
  final bool showDelete;
  final int index;
  final int id;
  final Pointer pointer;

  ReviewCard(
      {required this.username,
      required this.rating,
      required this.reviewText,
      required this.showDelete,
      required this.index,
      required this.id,
      required this.pointer});

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
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  'Confirm action',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                  ),
                                ),
                                content: Text(
                                  'This will delete your review permanently, are you sure you want to proceed?',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Delete'),
                                    onPressed: () async {
                                      FirestoreObject firestoreObject =
                                          FirestoreObject();
                                      bool success =
                                          await firestoreObject.deleteReview(
                                              widget.index, widget.id);
                                      if (success) {
                                        Navigator.pop(context);
                                        double newRating = 0;
                                        int newReviewCount = widget.pointer
                                                .updatedData['review_count'] -
                                            1;
                                        List reviews = widget
                                            .pointer.updatedData['reviews'];

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
                                        print(reviews);
                                        widget.pointer.updatedData['reviews'] =
                                            reviews;
                                        widget.pointer.updatedData['rating'] =
                                            newRating;
                                        widget.pointer
                                                .updatedData['review_count'] =
                                            newReviewCount;
                                      }
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Cancel'),
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
