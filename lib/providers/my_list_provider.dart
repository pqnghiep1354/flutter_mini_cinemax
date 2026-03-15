import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../repos/user_repo.dart';
import '../repos/movie_repo.dart';

class MyListProvider extends ChangeNotifier {
  final UserRepo _userRepo = UserRepo();
  final MovieRepo _movieRepo = MovieRepo();

  List<int> _favoriteIds = [];
  List<int> _myListIds = [];
  List<Movie> _favoriteMovies = [];
  List<Movie> _myListMovies = [];
  bool _isLoading = false;
  String? _uid;

  List<int> get favoriteIds => _favoriteIds;
  List<int> get myListIds => _myListIds;
  List<Movie> get favoriteMovies => _favoriteMovies;
  List<Movie> get myListMovies => _myListMovies;
  bool get isLoading => _isLoading;

  bool isFavorite(int movieId) => _favoriteIds.contains(movieId);
  bool isInMyList(int movieId) => _myListIds.contains(movieId);

  void setUser(String? uid) {
    _uid = uid;
    if (uid != null) {
      _loadUserLists();
    } else {
      _favoriteIds = [];
      _myListIds = [];
      _favoriteMovies = [];
      _myListMovies = [];
      notifyListeners();
    }
  }

  Future<void> _loadUserLists() async {
    if (_uid == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      final profile = await _userRepo.getUserProfile(_uid!);
      if (profile != null) {
        _favoriteIds = profile.favoriteMovieIds.toSet().toList();
        _myListIds = profile.myListMovieIds.toSet().toList();
        await _loadMovieDetails();
      }
    } catch (e) {
      debugPrint('Isolated Firestore error (MyList load): $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadMovieDetails() async {
    // Load favorite movie details
    _favoriteMovies = [];
    for (final id in _favoriteIds) {
      try {
        final movie = await _movieRepo.getMovieDetail(id);
        _favoriteMovies.add(movie);
      } catch (_) {}
    }

    // Load my list movie details
    _myListMovies = [];
    for (final id in _myListIds) {
      try {
        final movie = await _movieRepo.getMovieDetail(id);
        _myListMovies.add(movie);
      } catch (_) {}
    }
  }

  Future<void> toggleFavorite(int movieId) async {
    if (_uid == null) return;

    final wasFavorite = _favoriteIds.contains(movieId);
    final originalIds = List<int>.from(_favoriteIds);
    final originalMovies = List<Movie>.from(_favoriteMovies);

    try {
      if (wasFavorite) {
        _favoriteIds.remove(movieId);
        _favoriteMovies.removeWhere((m) => m.id == movieId);
        notifyListeners();
        await _userRepo.removeFromFavorites(_uid!, movieId);
      } else {
        if (!_favoriteIds.contains(movieId)) {
          _favoriteIds.add(movieId);
          final movie = await _movieRepo.getMovieDetail(movieId);
          if (!_favoriteMovies.any((m) => m.id == movieId)) {
            _favoriteMovies.add(movie);
          }
          notifyListeners();
          await _userRepo.addToFavorites(_uid!, movieId);
        }
      }
    } catch (e) {
      debugPrint('Firestore write error (toggleFavorite): $e');
      // Revert state on error
      _favoriteIds = originalIds;
      _favoriteMovies = originalMovies;
      notifyListeners();
      
      // Rethrow to allow UI to show error if needed, or handle here
      // For now, just logging to prevent crash
    }
  }

  Future<void> toggleMyList(int movieId) async {
    if (_uid == null) return;

    final wasInList = _myListIds.contains(movieId);
    final originalIds = List<int>.from(_myListIds);
    final originalMovies = List<Movie>.from(_myListMovies);

    try {
      if (wasInList) {
        _myListIds.remove(movieId);
        _myListMovies.removeWhere((m) => m.id == movieId);
        notifyListeners();
        await _userRepo.removeFromMyList(_uid!, movieId);
      } else {
        if (!_myListIds.contains(movieId)) {
          _myListIds.add(movieId);
          final movie = await _movieRepo.getMovieDetail(movieId);
          if (!_myListMovies.any((m) => m.id == movieId)) {
            _myListMovies.add(movie);
          }
          notifyListeners();
          await _userRepo.addToMyList(_uid!, movieId);
        }
      }
    } catch (e) {
      debugPrint('Firestore write error (toggleMyList): $e');
      // Revert state on error
      _myListIds = originalIds;
      _myListMovies = originalMovies;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _loadUserLists();
  }
}
