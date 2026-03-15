import '../models/genre.dart';
import 'tmdb_api_service.dart';

class GenreRepo {
  final TmdbApiService _api = TmdbApiService();

  Future<List<Genre>> getMovieGenres() async {
    final response = await _api.get('/genre/movie/list');
    final genres = response.data['genres'] as List;
    return genres.map((json) => Genre.fromJson(json)).toList();
  }

  Future<List<Genre>> getTvGenres() async {
    final response = await _api.get('/genre/tv/list');
    final genres = response.data['genres'] as List;
    return genres.map((json) => Genre.fromJson(json)).toList();
  }
}
