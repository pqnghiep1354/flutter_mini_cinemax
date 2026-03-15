import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';
import '../models/cast.dart';
import '../models/review.dart';
import '../models/video.dart';
import 'tmdb_api_service.dart';

class MovieRepo {
  final TmdbApiService _api = TmdbApiService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Movie>> getTrending({int page = 1}) async {
    final response = await _api.get(
      '/trending/movie/week',
      queryParameters: {'page': page},
    );
    final results = response.data['results'] as List;
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await _api.get(
      '/movie/popular',
      queryParameters: {'page': page},
    );
    final results = response.data['results'] as List;
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await _api.get(
      '/movie/top_rated',
      queryParameters: {'page': page},
    );
    final results = response.data['results'] as List;
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await _api.get(
      '/movie/now_playing',
      queryParameters: {'page': page},
    );
    final results = response.data['results'] as List;
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await _api.get(
      '/movie/upcoming',
      queryParameters: {'page': page},
    );
    final results = response.data['results'] as List;
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  Future<Movie> getMovieDetail(int movieId) async {
    final response = await _api.get('/movie/$movieId');
    return Movie.fromJson(response.data);
  }

  Future<List<Cast>> getCredits(int movieId) async {
    final response = await _api.get('/movie/$movieId/credits');
    final cast = response.data['cast'] as List;
    return cast.map((json) => Cast.fromJson(json)).toList();
  }

  Future<List<Review>> getReviews(int movieId, {int page = 1}) async {
    final response = await _api.get(
      '/movie/$movieId/reviews',
      queryParameters: {'page': page},
    );
    final results = response.data['results'] as List;
    return results.map((json) => Review.fromJson(json)).toList();
  }

  Future<List<Video>> getVideos(int movieId) async {
    final response = await _api.get('/movie/$movieId/videos');
    final results = response.data['results'] as List;
    return results.map((json) => Video.fromJson(json)).toList();
  }

  Future<List<Movie>> getSimilar(int movieId, {int page = 1}) async {
    final response = await _api.get(
      '/movie/$movieId/similar',
      queryParameters: {'page': page},
    );
    final results = response.data['results'] as List;
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  Future<List<Movie>> discoverByGenre(int genreId, {int page = 1}) async {
    final response = await _api.get(
      '/discover/movie',
      queryParameters: {
        'with_genres': genreId,
        'page': page,
        'sort_by': 'popularity.desc',
      },
    );
    final results = response.data['results'] as List;
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> getPersonDetail(int personId) async {
    final response = await _api.get('/person/$personId');
    return response.data;
  }

  Future<List<Movie>> getPersonMovieCredits(int personId) async {
    final response = await _api.get('/person/$personId/movie_credits');
    final cast = response.data['cast'] as List;
    return cast.map((json) => Movie.fromJson(json)).toList();
  }

  // Firestore Reviews
  Future<List<Review>> getLocalReviews(int movieId) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('movieId', isEqualTo: movieId)
        .orderBy('created_at', descending: true)
        .get();
    
    return snapshot.docs.map((doc) => Review.fromFirestore({
      ...doc.data(),
      'id': doc.id,
    })).toList();
  }

  Future<void> addReview(int movieId, Review review) async {
    await _firestore.collection('reviews').add({
      ...review.toFirestore(),
      'movieId': movieId,
    });
  }
}
