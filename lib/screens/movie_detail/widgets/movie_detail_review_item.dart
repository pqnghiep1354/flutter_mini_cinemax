import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_text_styles.dart';
import '../../../models/review.dart';
import '../../../widgets/cached_image.dart';

class MovieDetailReviewItem extends StatelessWidget {
  final Review review;

  const MovieDetailReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: review.fullAvatarPath.isNotEmpty
                    ? CachedImage(
                        imageUrl: review.fullAvatarPath,
                        width: 40,
                        height: 40,
                      )
                    : Container(
                        width: 40,
                        height: 40,
                        color: AppColors.shimmerBase,
                        child: const Icon(Icons.person,
                            color: AppColors.mediumGrey, size: 20),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.author,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (review.rating != null)
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.star, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            review.rating!.toStringAsFixed(1),
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.content,
            style: AppTextStyles.bodySmall.copyWith(
              height: 1.5,
              color: AppColors.textSecondary,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}
