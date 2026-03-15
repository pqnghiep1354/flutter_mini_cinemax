import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../providers/series_provider.dart';
import '../../widgets/loading_indicator.dart';

import 'widgets/series_detail_header.dart';
import 'widgets/series_detail_episode_list.dart';

class SeriesDetailScreen extends StatefulWidget {
  final int seriesId;

  const SeriesDetailScreen({super.key, required this.seriesId});

  @override
  State<SeriesDetailScreen> createState() => _SeriesDetailScreenState();
}

class _SeriesDetailScreenState extends State<SeriesDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SeriesProvider>().loadSeriesDetail(widget.seriesId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SeriesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const LoadingIndicator();

          final series = provider.seriesDetail;
          if (series == null) return const SizedBox.shrink();

          return CustomScrollView(
            slivers: [
              SeriesDetailHeader(series: series),
              // Series info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Story Line', style: AppTextStyles.heading4),
                      const SizedBox(height: 8),
                      Text(
                        series.overview ?? 'No description.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Watch trailer button
                      if (provider.trailer != null)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => context.push(
                              '/trailer?key=${provider.trailer!.key}&title=${Uri.encodeComponent(provider.trailer!.name)}',
                            ),
                            icon: const Icon(Icons.play_circle_outline),
                            label: const Text('Watch Trailer'),
                          ),
                        ),
                      const SizedBox(height: 24),
                      // Season selector
                      if (provider.seasons.isNotEmpty) ...[
                        Text('Seasons', style: AppTextStyles.heading4),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.seasons.length,
                            itemBuilder: (context, index) {
                              final isSelected =
                                  index == provider.selectedSeasonIndex;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                  onTap: () => provider.selectSeason(
                                      index, widget.seriesId),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.border,
                                      ),
                                    ),
                                    child: Text(
                                      provider.seasons[index].name,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // Episodes
              SliverToBoxAdapter(
                child: provider.isLoadingEpisodes
                    ? const Padding(
                        padding: EdgeInsets.all(32),
                        child: LoadingIndicator(),
                      )
                    : SeriesDetailEpisodeList(episodes: provider.episodes),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }
}
