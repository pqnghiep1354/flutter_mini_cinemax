class AppConstants {
  AppConstants._();

  // TMDB
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';
  static const String posterW500 = '$tmdbImageBaseUrl/w500';
  static const String posterW342 = '$tmdbImageBaseUrl/w342';
  static const String posterW185 = '$tmdbImageBaseUrl/w185';
  static const String backdropW780 = '$tmdbImageBaseUrl/w780';
  static const String backdropOriginal = '$tmdbImageBaseUrl/original';
  static const String profileW185 = '$tmdbImageBaseUrl/w185';

  // YouTube
  static const String youtubeBaseUrl = 'https://www.youtube.com/watch?v=';
  static const String youtubeThumbnailUrl = 'https://img.youtube.com/vi';

  // Spacing
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;

  // Radius
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusRound = 28.0;

  // Sizes
  static const double movieCardWidth = 150.0;
  static const double movieCardHeight = 220.0;
  static const double carouselHeight = 450.0;
  static const double bottomNavHeight = 60.0;

  // Animation durations
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Pagination
  static const int defaultPageSize = 20;

  // Firestore collections
  static const String usersCollection = 'users';
  static const String myListCollection = 'my_list';
  static const String favoritesCollection = 'favorites';
  static const String reviewsCollection = 'reviews';
}
