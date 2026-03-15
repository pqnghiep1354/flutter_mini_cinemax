import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_text_styles.dart';
import '../../../providers/my_list_provider.dart';
import '../../../providers/auth_provider.dart' as app_auth;
import 'package:go_router/go_router.dart';

class MovieDetailActionButtons extends StatelessWidget {
  final int movieId;

  const MovieDetailActionButtons({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    final myListProvider = context.watch<MyListProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAction(
            icon: myListProvider.isFavorite(movieId)
                ? Icons.favorite
                : Icons.favorite_border,
            label: 'Favorite',
            color: myListProvider.isFavorite(movieId)
                ? AppColors.primary
                : AppColors.mediumGrey,
            onTap: () {
              final auth = context.read<app_auth.AuthProvider>();
              if (auth.user == null) {
                _showGuestInfo(context);
              } else {
                myListProvider.toggleFavorite(movieId);
              }
            },
          ),
          _buildAction(
            icon: myListProvider.isInMyList(movieId)
                ? Icons.bookmark
                : Icons.bookmark_border,
            label: 'My List',
            color: myListProvider.isInMyList(movieId)
                ? AppColors.primary
                : AppColors.mediumGrey,
            onTap: () {
              final auth = context.read<app_auth.AuthProvider>();
              if (auth.user == null) {
                _showGuestInfo(context);
              } else {
                myListProvider.toggleMyList(movieId);
              }
            },
          ),
          _buildAction(
            icon: Icons.share_outlined,
            label: 'Share',
            color: AppColors.mediumGrey,
            onTap: () {
              Share.share(
                'Check out this movie on CineMax! https://www.themoviedb.org/movie/$movieId',
              );
            },
          ),
        ],
      ),
    );
  }

  void _showGuestInfo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Please login to use this feature'),
        action: SnackBarAction(
          label: 'Login',
          onPressed: () => context.go('/welcome'),
        ),
      ),
    );
  }

  Widget _buildAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
