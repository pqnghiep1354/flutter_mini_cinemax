import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../providers/search_provider.dart';
import 'widgets/search_result_item.dart';
import 'widgets/search_not_found.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<SearchProvider>(
          builder: (context, provider, _) {
            return TextField(
              autofocus: true,
              onChanged: provider.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search movies, series...',
                border: InputBorder.none,
                hintStyle: const TextStyle(color: AppColors.textHint),
                suffixIcon: provider.query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: provider.clearSearch,
                      )
                    : null,
              ),
            );
          },
        ),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.isEmptySearch) {
            return const SearchNotFound();
          }

          if (provider.query.isEmpty) {
            return const Center(
              child: Text(
                'Search for movies and TV shows',
                style: TextStyle(color: AppColors.textHint),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.results.length,
            itemBuilder: (context, index) {
              return SearchResultItem(movie: provider.results[index]);
            },
          );
        },
      ),
    );
  }
}
