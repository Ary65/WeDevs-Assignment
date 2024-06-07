import 'package:flutter/material.dart';

class RatingStarsWidget extends StatelessWidget {
  final double rating;

  const RatingStarsWidget({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final fullStars = rating.floor();
    final hasHalfStar = rating - fullStars >= 0.5;
    final emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      children: [
        ...List.filled(fullStars, const Icon(Icons.star, color: Colors.amber)),
        if (hasHalfStar) const Icon(Icons.star_half, color: Colors.amber),
        ...List.filled(
            emptyStars, const Icon(Icons.star_border, color: Colors.amber)),
      ],
    );
  }
}
