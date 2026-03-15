import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/genre.dart';
import '../repos/movie_repo.dart';
import '../repos/genre_repo.dart';

class HomeProvider extends ChangeNotifier {
  final MovieRepo _movieRepo = MovieRepo();
  final GenreRepo _genreRepo = GenreRepo();

  List<Movie> _trending = [];
  List<Movie> _popular = [];
  List<Movie> _topRated = [];
  List<Movie> _nowPlaying = [];
  List<Movie> _upcoming = [];
  List<Genre> _genres = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedGenreIndex = 0;

  List<Movie> get trending => _trending;
  List<Movie> get popular => _popular;
  List<Movie> get topRated => _topRated;
  List<Movie> get nowPlaying => _nowPlaying;
  List<Movie> get upcoming => _upcoming;
  List<Genre> get genres => _genres;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get selectedGenreIndex => _selectedGenreIndex;

  Future<void> loadHomeData() async {
    if (_trending.isNotEmpty) return; // Already loaded

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _movieRepo.getTrending(),
        _movieRepo.getPopular(),
        _movieRepo.getTopRated(),
        _movieRepo.getNowPlaying(),
        _movieRepo.getUpcoming(),
        _genreRepo.getMovieGenres(),
      ]);

      _trending = results[0] as List<Movie>;
      _popular = results[1] as List<Movie>;
      _topRated = results[2] as List<Movie>;
      _nowPlaying = results[3] as List<Movie>;
      _upcoming = results[4] as List<Movie>;
      _genres = results[5] as List<Genre>;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectGenre(int index) {
    _selectedGenreIndex = index;
    notifyListeners();
  }

  Future<void> refresh() async {
    _trending = [];
    _popular = [];
    _topRated = [];
    _nowPlaying = [];
    _upcoming = [];
    await loadHomeData();
  }
}
