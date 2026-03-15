import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_text_styles.dart';
import '../../../models/genre.dart';
import '../../../models/movie.dart';
import '../../../widgets/cached_image.dart';
import '../../../widgets/loading_indicator.dart';

class ExploreGenreGrid extends StatefulWidget {
  final List<Genre> genres;
  final int? selectedGenreId;
  final List<Movie> discoverResults;
  final bool isLoadingDiscover;
  final bool isLoadingMore;
  final ValueChanged<int> onGenreSelected;
  final VoidCallback onClearDiscover;
  final VoidCallback onLoadMore;

  const ExploreGenreGrid({
    super.key,
    required this.genres,
    this.selectedGenreId,
    required this.discoverResults,
    required this.isLoadingDiscover,
    required this.isLoadingMore,
    required this.onGenreSelected,
    required this.onClearDiscover,
    required this.onLoadMore,
  });

  @override
  State<ExploreGenreGrid> createState() => _ExploreGenreGridState();
}

class _ExploreGenreGridState extends State<ExploreGenreGrid> {
  final ScrollController _scrollController = ScrollController();

  static const List<Color> _genreColors = [
    Color(0xFFE21221),
    Color(0xFF2196F3),
    Color(0xFF4CAF50),
    Color(0xFFFF9800),
    Color(0xFF9C27B0),
    Color(0xFF00BCD4),
    Color(0xFFFF5722),
    Color(0xFF795548),
    Color(0xFF607D8B),
    Color(0xFFE91E63),
    Color(0xFF3F51B5),
    Color(0xFFCDDC39),
    Color(0xFF009688),
    Color(0xFFFFC107),
    Color(0xFF8BC34A),
    Color(0xFF673AB7),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !widget.isLoadingMore &&
        !widget.isLoadingDiscover) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedGenreId != null) {
      return _buildDiscoverResults(context);
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: widget.genres.length,
      itemBuilder: (context, index) {
        final genre = widget.genres[index];
        final color = _genreColors[index % _genreColors.length];

        return GestureDetector(
          onTap: () => widget.onGenreSelected(genre.id),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                genre.name,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiscoverResults(BuildContext context) {
    if (widget.isLoadingDiscover) {
      return const LoadingIndicator();
    }

    return Column(
      children: [
        // Back button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.onClearDiscover,
                child: const Icon(Icons.arrow_back, size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                widget.genres
                    .firstWhere((g) => g.id == widget.selectedGenreId,
                        orElse: () => Genre(id: 0, name: 'Movies'))
                    .name,
                style: AppTextStyles.heading4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.55,
            ),
            itemCount: widget.discoverResults.length + (widget.isLoadingMore ? 3 : 0),
            itemBuilder: (context, index) {
              if (index < widget.discoverResults.length) {
                final movie = widget.discoverResults[index];
                return GestureDetector(
                  onTap: () => context.push('/movie/${movie.id}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CachedImage(
                          imageUrl: movie.fullPosterPath,
                          borderRadius: 12,
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        movie.title,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }
              return const Center(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ));
            },
          ),
        ),
      ],
    );
  }
}
