import 'package:flutter/material.dart';

class StarRatingBar extends StatelessWidget {
  final double rating;
  final double size;

  StarRatingBar({required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    List<int> indexList = [0, 1, 2, 3, 4];
    if (rating <= 5 && rating >= 0) {
      return Container(
        child: Row(
            children: indexList.map((index) {
          int numFullStars = rating.round() - 2;
          if (index <= numFullStars) {
            return Icon(
              Icons.star,
              color: Colors.amberAccent,
              size: size,
            );
          } else if (index == numFullStars + 1) {
            if (rating % 1 == 0) {
              return Icon(
                Icons.star,
                color: Colors.amberAccent,
                size: size,
              );
            } else {
              return Icon(
                Icons.star_half,
                color: Colors.amberAccent,
                size: size,
              );
            }
          } else {
            return Icon(
              Icons.star_border,
              color: Colors.amberAccent,
              size: size,
            );
          }
        }).toList()),
      );
    } else {
      return Container(child: Text('Rating out of bounds'));
    }
  }
}
