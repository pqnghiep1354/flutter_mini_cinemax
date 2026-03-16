import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../providers/movie_detail_provider.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart';
import 'widgets/movie_detail_header.dart';
import 'widgets/movie_detail_info.dart';
import 'widgets/movie_detail_cast_list.dart';
import 'widgets/movie_detail_tab_bar.dart';
import 'widgets/movie_detail_action_buttons.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieDetailProvider>().loadMovieDetail(widget.movieId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieDetailProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingIndicator();
          }

          if (provider.errorMessage != null) {
            return AppErrorWidget(
              message: provider.errorMessage!,
              onRetry: () => provider.loadMovieDetail(widget.movieId),
            );
          }

          final movie = provider.movie;
          if (movie == null) return const SizedBox.shrink();

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // Header with backdrop
                MovieDetailHeader(movie: movie),

                // Action buttons (Favorite, My List, Share)
                SliverToBoxAdapter(
                  child: MovieDetailActionButtons(movieId: movie.id),
                ),

                // Info section
                SliverToBoxAdapter(
                  child: MovieDetailInfo(movie: movie),
                ),

                // Cast
                if (provider.cast.isNotEmpty)
                  SliverToBoxAdapter(
                    child: MovieDetailCastList(cast: provider.cast),
                  ),

                // Sticky TabBar
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.primary,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: AppColors.mediumGrey,
                      labelStyle: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      tabs: const [
                        Tab(text: 'Trailers'),
                        Tab(text: 'Reviews'),
                        Tab(text: 'Similar'),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                MovieDetailTabBar(
                  initialTab: MovieDetailTabType.trailers,
                  videos: provider.videos,
                  reviews: provider.reviews,
                  similar: provider.similar,
                  hasMoreReviews: provider.hasMoreReviews,
                  isLoadingMoreReviews: provider.isLoadingMoreReviews,
                ),
                MovieDetailTabBar(
                  initialTab: MovieDetailTabType.reviews,
                  videos: provider.videos,
                  reviews: provider.reviews,
                  similar: provider.similar,
                  hasMoreReviews: provider.hasMoreReviews,
                  isLoadingMoreReviews: provider.isLoadingMoreReviews,
                ),
                MovieDetailTabBar(
                  initialTab: MovieDetailTabType.similar,
                  videos: provider.videos,
                  reviews: provider.reviews,
                  similar: provider.similar,
                  hasMoreReviews: provider.hasMoreReviews,
                  isLoadingMoreReviews: provider.isLoadingMoreReviews,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
