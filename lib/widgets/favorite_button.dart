import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../providers/my_list_provider.dart';

class FavoriteButton extends StatelessWidget {
  final int movieId;
  final double size;

  const FavoriteButton({
    super.key,
    required this.movieId,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final myListProvider = context.watch<MyListProvider>();
    final isFavorite = myListProvider.isFavorite(movieId);

    return GestureDetector(
      onTap: () => myListProvider.toggleFavorite(movieId),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(isFavorite),
          color: isFavorite ? AppColors.primary : AppColors.mediumGrey,
          size: size,
        ),
      ),
    );
  }
}
