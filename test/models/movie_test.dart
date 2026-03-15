import 'package:flutter_test/flutter_test.dart';
import 'package:cinemax/models/movie.dart';

void main() {
  group('Movie Model Tests', () {
    test('fromJson should create a valid Movie object', () {
      final json = {
        'id': 1,
        'title': 'Test Movie',
        'overview': 'Overview text',
        'poster_path': '/poster.jpg',
        'backdrop_path': '/backdrop.jpg',
        'vote_average': 8.5,
        'vote_count': 100,
        'release_date': '2024-01-01',
        'genre_ids': [12, 18],
        'popularity': 120.0,
      };

      final movie = Movie.fromJson(json);

      expect(movie.id, 1);
      expect(movie.title, 'Test Movie');
      expect(movie.overview, 'Overview text');
      expect(movie.posterPath, '/poster.jpg');
      expect(movie.backdropPath, '/backdrop.jpg');
      expect(movie.voteAverage, 8.5);
      expect(movie.voteCount, 100);
      expect(movie.releaseDate, '2024-01-01');
      expect(movie.genreIds, [12, 18]);
      expect(movie.popularity, 120.0);
      expect(movie.year, '2024');
      expect(movie.ratingFormatted, '8.5');
    });

    test('toJson should return a valid Map', () {
      final movie = Movie(
        id: 1,
        title: 'Test Movie',
        posterPath: '/poster.jpg',
      );

      final json = movie.toJson();

      expect(json['id'], 1);
      expect(json['title'], 'Test Movie');
      expect(json['poster_path'], '/poster.jpg');
    });
  });
}
