import '../models/movie.dart';
import 'tmdb_api_service.dart';

class SearchRepo {
  final TmdbApiService _api = TmdbApiService();

  Future<List<Movie>> multiSearch(String query, {int page = 1}) async {
    final response = await _api.get(
      '/search/multi',
      queryParameters: {
        'query': query,
        'page': page,
        'include_adult': false,
      },
    );
    final results = response.data['results'] as List;
    // Filter to only movies and TV shows
    return results
        .where((item) =>
            item['media_type'] == 'movie' || item['media_type'] == 'tv')
        .map((json) => Movie.fromJson(json))
        .toList();
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final response = await _api.get(
      '/search/movie',
      queryParameters: {
        'query': query,
        'page': page,
      },
    );
    final results = response.data['results'] as List;
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  Future<List<Movie>> searchTv(String query, {int page = 1}) async {
    final response = await _api.get(
      '/search/tv',
      queryParameters: {
        'query': query,
        'page': page,
      },
    );
    final results = response.data['results'] as List;
    return results.map((json) => Movie.fromJson(json)).toList();
  }
}
