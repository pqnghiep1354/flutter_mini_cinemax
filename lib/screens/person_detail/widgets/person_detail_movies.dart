import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_text_styles.dart';
import '../../../models/movie.dart';
import '../../../widgets/cached_image.dart';

class PersonDetailMovies extends StatelessWidget {
  final List<Movie> movieCredits;

  const PersonDetailMovies({super.key, required this.movieCredits});

  @override
  Widget build(BuildContext context) {
    if (movieCredits.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Known For', style: AppTextStyles.heading4),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movieCredits.length > 10 ? 10 : movieCredits.length,
            itemBuilder: (context, index) {
              final movie = movieCredits[index];
              return GestureDetector(
                onTap: () => context.push('/movie/${movie.id}'),
                child: Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: 12),
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
                      const SizedBox(height: 8),
                      Text(
                        movie.title,
                        style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
