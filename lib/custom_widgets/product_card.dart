import 'package:flutter/material.dart';
import 'package:shpownow/custom_widgets/star_rating_bar.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String image;
  final int reviewCount;
  final double rating;
  final int id;
  final double price;

  ProductCard({
    required this.title,
    required this.image,
    required this.reviewCount,
    required this.rating,
    required this.id,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1.0,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.325,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                image,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        StarRatingBar(
                          rating: rating,
                          size: 25.0,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          '$reviewCount',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 13.0,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey[800],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    '₹ $price',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
