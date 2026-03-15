import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieDetailProvider>().loadMovieDetail(widget.movieId);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        child: Consumer<MovieDetailProvider>(
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

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
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

                // Tabs (Trailers, Reviews, Similar)
                SliverToBoxAdapter(
                  child: MovieDetailTabBar(
                    videos: provider.videos,
                    reviews: provider.reviews,
                    similar: provider.similar,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            );
          },
        ),
      ),
    );
  }
}
