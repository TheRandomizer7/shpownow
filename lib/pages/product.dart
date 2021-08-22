import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shpownow/custom_widgets/review_card.dart';
import 'package:shpownow/custom_widgets/star_rating_bar.dart';
import 'package:shpownow/services/custom%20classes/review_data.dart';
import 'package:shpownow/services/flutter_services/firestore.dart';
import 'package:shpownow/services/store_api.dart';

bool addReviewIsVisible = false;

class Product extends StatefulWidget {
  final Map data;
  final StoreProducts storeProducts;

  @override
  _ProductState createState() => _ProductState();

  Product({required this.data, required this.storeProducts});
}

class _ProductState extends State<Product> {
  ReviewData reviewData = ReviewData(null);
  @override
  Widget build(BuildContext context) {
    Map data = widget.data;
    if (data.length == 0) {
      data = (ModalRoute.of(context)!.settings.arguments as Map);
    }

    if (reviewData.updatedData == null) {
      reviewData.updatedData = data;
    }

    data = reviewData.updatedData;

    String title = data['title'];
    String image = data['image'];
    String description = data['description'];
    double customerRating = 3.0;

    TextEditingController _reviewText = TextEditingController();
    FirestoreObject firestoreObject = FirestoreObject();

    Dialog reviewDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 3.0, color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Write your review here',
                style: TextStyle(
                    fontSize: 20.0,
                    letterSpacing: 2.0,
                    fontFamily: 'Roboto',
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 20.0,
              ),
              RatingBar(
                initialRating: customerRating,
                glow: false,
                allowHalfRating: true,
                ratingWidget: RatingWidget(
                    empty: Icon(
                      Icons.star_outline,
                      color: Colors.amber,
                    ),
                    half: Icon(
                      Icons.star_half,
                      color: Colors.amber,
                    ),
                    full: Icon(
                      Icons.star,
                      color: Colors.amber,
                    )),
                onRatingUpdate: (rating) {
                  customerRating = rating;
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Posting review publicly as ${data['username']}',
                style: TextStyle(
                    fontSize: 15.0,
                    letterSpacing: 2.0,
                    fontFamily: 'Roboto',
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextFormField(
                maxLines: null,
                controller: _reviewText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Your review',
                  labelStyle: TextStyle(
                    color: Colors.grey[800],
                    fontFamily: 'Roboto',
                    letterSpacing: 1.0,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w800,
                  ),
                  hintText: 'Enter your feedback here',
                ),
                style: TextStyle(
                  color: Colors.grey[800],
                  fontFamily: 'Roboto',
                  letterSpacing: 1.0,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              MaterialButton(
                color: Colors.green[400],
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Post review',
                        style: TextStyle(
                          fontSize: 23.0,
                          fontFamily: 'Roboto',
                          letterSpacing: 2.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 25.0,
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  bool success = await firestoreObject.addProductReview(
                      _reviewText.text,
                      customerRating,
                      data['username'],
                      data['id'],
                      data['uid']);
                  if (success) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Review added',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ]),
                    ));
                    Navigator.pop(context);
                    setState(() {
                      List reviews = data['reviews'];
                      reviews.add({
                        'review_text': _reviewText.text,
                        'rating': customerRating,
                        'username': data['username'],
                        'uid': data['uid'],
                      });
                      int newReviewCount = data['review_count'] + 1;
                      double currentRating = data['rating'];
                      double newRating =
                          (((((currentRating * data['review_count']) +
                                              customerRating) /
                                          (newReviewCount / 2))
                                      .round()
                                      .toDouble()) /
                                  2)
                              .toDouble();
                      data['reviews'] = reviews;
                      data['rating'] = newRating;
                      data['review_count'] = newReviewCount;
                      reviewData.updatedData = data;
                    });
                  }
                },
              ),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(
                Icons.shopping_basket,
                color: Colors.grey[800],
              ),
              SizedBox(
                width: 20.0,
              ),
              Container(
                height: 30.0,
                width: 2.0,
                color: Colors.deepOrange[600],
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                'Shpownow',
                style: TextStyle(
                    fontSize: 20.0,
                    letterSpacing: 2.0,
                    fontFamily: 'Roboto',
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w800),
              )
            ],
          ),
          backgroundColor: Colors.deepOrange[300],
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: data['reviews'].length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              String reviewDisplayText = 'Customer reviews';
              if (data['reviews'].length == 0) {
                reviewDisplayText = 'No reviews for this product';
              }
              return Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
                  child: Column(
                    children: [
                      Center(
                        child: Image.network(
                          image,
                          height: 200.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 5.0,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.deepOrange[100],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        '₹ ${data['price']}',
                        style: TextStyle(
                            fontSize: 25.0,
                            letterSpacing: 0.0,
                            fontFamily: 'Roboto',
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 18.0,
                            letterSpacing: 2.0,
                            fontFamily: 'Roboto',
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 2.0,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey[300],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                            fontSize: 15.0,
                            letterSpacing: 1.0,
                            fontFamily: 'Roboto',
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: MaterialButton(
                          color: Colors.lightGreen[100],
                          child: Text(
                            data['category'],
                            style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Roboto',
                              letterSpacing: 2.0,
                              color: Colors.green[800],
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          onPressed: () {
                            widget.storeProducts.productsToLoad.value =
                                data['category'];
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 5.0,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.deepOrange[100],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      MaterialButton(
                        color: Colors.deepOrange[100],
                        child: Container(
                            margin: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart,
                                  color: Colors.red[300],
                                  size: 25.0,
                                ),
                                SizedBox(
                                  width: 30.0,
                                ),
                                Text(
                                  'Add to cart',
                                  style: TextStyle(
                                    fontSize: 23.0,
                                    fontFamily: 'Roboto',
                                    letterSpacing: 2.0,
                                    color: Colors.red[300],
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            )),
                        onPressed: () async {
                          bool success = await firestoreObject.addProductToCart(
                              data['uid'], data['id']);
                          if (success) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Item added to cart',
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
                      SizedBox(
                        height: 50.0,
                      ),
                      Text(
                        reviewDisplayText,
                        style: TextStyle(
                            fontSize: 18.0,
                            letterSpacing: 2.0,
                            fontFamily: 'Roboto',
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StarRatingBar(
                            rating: double.parse('${data['rating']}'),
                            size: 40,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            '${data['review_count']}',
                            style: TextStyle(
                              fontSize: 18.0,
                              letterSpacing: 2.0,
                              fontFamily: 'Roboto',
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              );
            } else if (index < data['reviews'].length + 1) {
              int tempIndex = index - 1;
              return ReviewCard(
                username: data['reviews'][tempIndex]['username'],
                rating: double.parse('${data['reviews'][tempIndex]['rating']}'),
                reviewText: data['reviews'][tempIndex]['review_text'],
                showDelete: (data['uid'] == data['reviews'][tempIndex]['uid']),
                index: tempIndex,
                id: data['id'],
                reviewData: reviewData,
              );
            } else {
              return Container(
                margin: EdgeInsets.fromLTRB(75.0, 30.0, 75.0, 30.0),
                child: MaterialButton(
                  color: Colors.blue[100],
                  child: Container(
                      margin: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.blue[300],
                            size: 30.0,
                          ),
                          SizedBox(
                            width: 30.0,
                          ),
                          Text(
                            'Add review',
                            style: TextStyle(
                              fontSize: 23.0,
                              fontFamily: 'Roboto',
                              letterSpacing: 2.0,
                              color: Colors.blue[300],
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      )),
                  onPressed: () {
                    setState(() {
                      //addReviewIsVisible = true;
                      showModal(
                          configuration: FadeScaleTransitionConfiguration(
                            transitionDuration: Duration(milliseconds: 300),
                          ),
                          context: context,
                          builder: (context) => reviewDialog);
                    });
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
