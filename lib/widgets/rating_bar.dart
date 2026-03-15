import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../config/app_colors.dart';

class AppRatingBar extends StatelessWidget {
  final double rating;
  final double size;
  final bool interactive;
  final ValueChanged<double>? onRatingUpdate;

  const AppRatingBar({
    super.key,
    required this.rating,
    this.size = 16,
    this.interactive = false,
    this.onRatingUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating / 2, // TMDB uses 10-scale, convert to 5
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: size,
      ignoreGestures: !interactive,
      unratedColor: AppColors.mediumGrey.withValues(alpha: 0.3),
      itemBuilder: (context, _) => const Icon(
        Icons.star_rounded,
        color: AppColors.star,
      ),
      onRatingUpdate: onRatingUpdate ?? (_) {},
    );
  }
}
