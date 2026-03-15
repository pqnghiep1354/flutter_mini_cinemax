import 'package:flutter/material.dart';
import '../../../config/app_text_styles.dart';
import '../../../models/movie.dart';

class MovieDetailInfo extends StatelessWidget {
  final Movie movie;

  const MovieDetailInfo({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('Story Line', style: AppTextStyles.heading4),
          const SizedBox(height: 8),
          Text(
            movie.overview ?? 'No description available.',
            style: AppTextStyles.bodyMedium.copyWith(
              height: 1.6,
              color: const Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
