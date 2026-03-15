import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_text_styles.dart';
import '../../providers/my_list_provider.dart';
import '../../widgets/loading_indicator.dart';
import 'widgets/my_list_movie_item.dart';
import 'widgets/my_list_empty_state.dart';

class MyListScreen extends StatelessWidget {
  const MyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My List', style: AppTextStyles.heading3),
          bottom: TabBar(
            indicatorColor: const Color(0xFFE21221),
            labelColor: const Color(0xFFE21221),
            unselectedLabelColor: const Color(0xFF9E9E9E),
            labelStyle: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
            tabs: const [
              Tab(text: 'My List'),
              Tab(text: 'Favorites'),
            ],
          ),
        ),
        body: Consumer<MyListProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) return const LoadingIndicator();

            return TabBarView(
              children: [
                // My List tab
                provider.myListMovies.isEmpty
                    ? const MyListEmptyState(
                        title: 'Your List is Empty',
                        subtitle:
                            'It seems that you haven\'t added\nany movies to your list.',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.myListMovies.length,
                        itemBuilder: (context, index) {
                          return MyListMovieItem(
                              movie: provider.myListMovies[index]);
                        },
                      ),
                // Favorites tab
                provider.favoriteMovies.isEmpty
                    ? const MyListEmptyState(
                        title: 'No Favorites Yet',
                        subtitle:
                            'Mark your favorite movies by\ntapping the heart icon.',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.favoriteMovies.length,
                        itemBuilder: (context, index) {
                          return MyListMovieItem(
                              movie: provider.favoriteMovies[index]);
                        },
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
