import 'package:flutter/material.dart';
import '../models/genre.dart';
import '../models/movie.dart';
import '../repos/genre_repo.dart';
import '../repos/movie_repo.dart';

class ExploreProvider extends ChangeNotifier {
  final GenreRepo _genreRepo = GenreRepo();
  final MovieRepo _movieRepo = MovieRepo();

  List<Genre> _genres = [];
  List<Movie> _discoverResults = [];
  int? _selectedGenreId;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isLoadingDiscover = false;
  bool _isLoadingMore = false;
  String? _errorMessage;

  List<Genre> get genres => _genres;
  List<Movie> get discoverResults => _discoverResults;
  int? get selectedGenreId => _selectedGenreId;
  bool get isLoading => _isLoading;
  bool get isLoadingDiscover => _isLoadingDiscover;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;

  Future<void> loadGenres() async {
    if (_genres.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _genres = await _genreRepo.getMovieGenres();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectGenre(int genreId) async {
    _selectedGenreId = genreId;
    _currentPage = 1;
    _isLoadingDiscover = true;
    notifyListeners();

    try {
      _discoverResults = await _movieRepo.discoverByGenre(genreId, page: _currentPage);
      _isLoadingDiscover = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoadingDiscover = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_selectedGenreId == null || _isLoadingMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final moreResults = await _movieRepo.discoverByGenre(_selectedGenreId!, page: _currentPage);
      _discoverResults.addAll(moreResults);
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void clearDiscover() {
    _selectedGenreId = null;
    _discoverResults = [];
    _currentPage = 1;
    notifyListeners();
  }
}
