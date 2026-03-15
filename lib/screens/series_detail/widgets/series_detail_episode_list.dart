import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_text_styles.dart';
import '../../../models/episode.dart';
import '../../../widgets/cached_image.dart';

class SeriesDetailEpisodeList extends StatelessWidget {
  final List<Episode> episodes;

  const SeriesDetailEpisodeList({super.key, required this.episodes});

  @override
  Widget build(BuildContext context) {
    if (episodes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: Text('No episodes available')),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Episodes', style: AppTextStyles.heading4),
          const SizedBox(height: 12),
          ...episodes.map((episode) => _buildEpisodeItem(episode)),
        ],
      ),
    );
  }

  Widget _buildEpisodeItem(Episode episode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Stack(
            children: [
              CachedImage(
                imageUrl: episode.fullStillPath,
                width: 140,
                height: 80,
                borderRadius: 12,
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'E${episode.episodeNumber}. ${episode.name}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (episode.runtimeFormatted.isNotEmpty)
                  Text(
                    episode.runtimeFormatted,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.mediumGrey,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  episode.overview ?? '',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
