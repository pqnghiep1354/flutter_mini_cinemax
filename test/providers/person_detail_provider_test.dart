import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cinemax/providers/person_detail_provider.dart';
import 'package:cinemax/repos/movie_repo.dart';
import 'package:cinemax/models/movie.dart';

// Import the generated mock
import 'person_detail_provider_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MovieRepo>()])
void main() {
  late PersonDetailProvider provider;
  late MockMovieRepo mockMovieRepo;

  setUp(() {
    mockMovieRepo = MockMovieRepo();
    provider = PersonDetailProvider(movieRepo: mockMovieRepo);
  });

  group('PersonDetailProvider Tests', () {
    test('initial state should be empty', () {
      expect(provider.person, isNull);
      expect(provider.movieCredits, isEmpty);
      expect(provider.isLoading, isFalse);
    });

    test('loadPersonDetail should update state on success', () async {
      final personJson = {
        'id': 123,
        'name': 'John Doe',
      };
      final movies = [
        Movie(id: 1, title: 'Movie 1', popularity: 10.0),
        Movie(id: 2, title: 'Movie 2', popularity: 20.0),
      ];

      when(mockMovieRepo.getPersonDetail(123)).thenAnswer((_) async => personJson);
      when(mockMovieRepo.getPersonMovieCredits(123)).thenAnswer((_) async => movies);

      final future = provider.loadPersonDetail(123);

      expect(provider.isLoading, isTrue);

      await future;

      expect(provider.isLoading, isFalse);
      expect(provider.person?.id, 123);
      expect(provider.movieCredits.length, 2);
      // Verify sorting (popularity 20.0 should be first)
      expect(provider.movieCredits[0].id, 2);
    });

    test('loadPersonDetail should update state on error', () async {
      when(mockMovieRepo.getPersonDetail(123)).thenThrow(Exception('API Error'));

      await provider.loadPersonDetail(123);

      expect(provider.isLoading, isFalse);
      expect(provider.person, isNull);
      expect(provider.errorMessage, contains('API Error'));
    });
  });
}
