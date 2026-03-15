import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/explore_provider.dart';
import '../../widgets/loading_indicator.dart';
import 'widgets/explore_search_bar.dart';
import 'widgets/explore_genre_grid.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ExploreProvider>().loadGenres();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Consumer<ExploreProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingIndicator();
          }

          return Column(
            children: [
              const ExploreSearchBar(),
              const SizedBox(height: 16),
              Expanded(
                child: ExploreGenreGrid(
                  genres: provider.genres,
                  selectedGenreId: provider.selectedGenreId,
                  discoverResults: provider.discoverResults,
                  isLoadingDiscover: provider.isLoadingDiscover,
                  isLoadingMore: provider.isLoadingMore,
                  onGenreSelected: provider.selectGenre,
                  onClearDiscover: provider.clearDiscover,
                  onLoadMore: provider.loadMore,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
