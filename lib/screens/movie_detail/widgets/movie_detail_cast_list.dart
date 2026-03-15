import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_text_styles.dart';
import '../../../models/cast.dart';
import '../../../widgets/cached_image.dart';

class MovieDetailCastList extends StatelessWidget {
  final List<Cast> cast;

  const MovieDetailCastList({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Cast', style: AppTextStyles.heading4),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cast.length > 10 ? 10 : cast.length,
            itemBuilder: (context, index) {
              final actor = cast[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () => context.push('/person/${actor.id}'),
                  child: Column(
                    children: [
                      ClipOval(
                        child: actor.fullProfilePath.isNotEmpty
                            ? CachedImage(
                                imageUrl: actor.fullProfilePath,
                                width: 60,
                                height: 60,
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                color: AppColors.shimmerBase,
                                child: const Icon(Icons.person,
                                    color: AppColors.mediumGrey),
                              ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 70,
                        child: Text(
                          actor.name,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
