import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/app_text_styles.dart';
import '../../providers/home_provider.dart';
import '../../widgets/loading_indicator.dart';
import 'widgets/top_movies_list_item.dart';

class TopMoviesScreen extends StatelessWidget {
  const TopMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Top 10 Movies This Week', style: AppTextStyles.heading4),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const LoadingIndicator();

          final topMovies = provider.topRated.take(10).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: topMovies.length,
            itemBuilder: (context, index) {
              return TopMoviesListItem(
                movie: topMovies[index],
                rank: index + 1,
              );
            },
          );
        },
      ),
    );
  }
}
