import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_text_styles.dart';
import '../../../models/video.dart';
import '../../../models/review.dart';
import '../../../models/movie.dart';
import 'package:provider/provider.dart';
import 'package:cinemax/providers/auth_provider.dart' as app_auth;
import 'package:cinemax/providers/movie_detail_provider.dart';
import '../../../widgets/cached_image.dart';
import 'movie_detail_review_item.dart';

class MovieDetailTabBar extends StatefulWidget {
  final List<Video> videos;
  final List<Review> reviews;
  final List<Movie> similar;

  const MovieDetailTabBar({
    super.key,
    required this.videos,
    required this.reviews,
    required this.similar,
  });

  @override
  State<MovieDetailTabBar> createState() => _MovieDetailTabBarState();
}

class _MovieDetailTabBarState extends State<MovieDetailTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        const SizedBox(height: 16),
        SizedBox(
          height: 600,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTrailers(),
              _buildReviews(),
              _buildSimilar(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrailers() {
    final youtubeVideos =
        widget.videos.where((v) => v.isYoutube).toList();

    if (youtubeVideos.isEmpty) {
      return const Center(child: Text('No trailers available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: youtubeVideos.length,
      itemBuilder: (context, index) {
        final video = youtubeVideos[index];
        return GestureDetector(
          onTap: () => context.push(
            '/trailer?key=${video.key}&title=${Uri.encodeComponent(video.name)}',
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      CachedImage(
                        imageUrl: video.thumbnailUrl,
                        width: 160,
                        height: 90,
                      ),
                      Positioned.fill(
                        child: Container(
                          color: Colors.black26,
                          child: const Icon(
                            Icons.play_circle_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        video.type,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviews() {
    return Column(
      children: [
        Consumer<app_auth.AuthProvider>(
          builder: (context, auth, _) {
            if (!auth.isLoggedIn) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Login to write a review',
                  style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton.icon(
                onPressed: _showAddReviewDialog,
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Write a Review'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 40),
                ),
              ),
            );
          },
        ),
        if (widget.reviews.isEmpty)
          const Expanded(child: Center(child: Text('No reviews yet')))
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.reviews.length + 1,
              itemBuilder: (context, index) {
                if (index == widget.reviews.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: TextButton(
                      onPressed: () => context.read<MovieDetailProvider>().loadMoreReviews(),
                      child: const Text('Load More Reviews'),
                    ),
                  );
                }
                return MovieDetailReviewItem(review: widget.reviews[index]);
              },
            ),
          ),
      ],
    );
  }

  void _showAddReviewDialog() {
    final auth = context.read<app_auth.AuthProvider>();
    final contentController = TextEditingController();
    double rating = 5.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Write a Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                hintText: 'Share your thoughts...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            const Text('Rating'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(10, (index) {
                return GestureDetector(
                  onTap: () => rating = (index + 1).toDouble(),
                  child: const Icon(Icons.star, color: Colors.amber, size: 20),
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (contentController.text.isNotEmpty) {
                final review = Review(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  author: auth.user?.displayName ?? 'Anonymous',
                  content: contentController.text,
                  rating: rating,
                  createdAt: DateTime.now().toIso8601String(),
                  avatarPath: auth.user?.photoURL,
                );
                context.read<MovieDetailProvider>().addReview(
                  context.read<MovieDetailProvider>().movie!.id,
                  review,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilar() {
    if (widget.similar.isEmpty) {
      return const Center(child: Text('No similar movies'));
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.55,
      ),
      itemCount: widget.similar.length,
      itemBuilder: (context, index) {
        final movie = widget.similar[index];
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
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
