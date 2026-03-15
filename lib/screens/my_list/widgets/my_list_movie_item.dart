import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_text_styles.dart';
import '../../../models/movie.dart';
import '../../../widgets/cached_image.dart';

class MyListMovieItem extends StatelessWidget {
  final Movie movie;

  const MyListMovieItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/movie/${movie.id}'),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            CachedImage(
              imageUrl: movie.fullPosterPath,
              width: 100,
              height: 140,
              borderRadius: 12,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: AppColors.star, size: 16),
                      const SizedBox(width: 4),
                      Text(movie.ratingFormatted,
                          style: AppTextStyles.bodySmall),
                    ],
                  ),
                  if (movie.year.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(movie.year, style: AppTextStyles.caption),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.mediumGrey),
          ],
        ),
      ),
    );
  }
}
