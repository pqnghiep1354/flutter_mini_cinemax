import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/cast.dart';
import '../models/review.dart';
import '../models/video.dart';
import '../repos/movie_repo.dart';

class MovieDetailProvider extends ChangeNotifier {
  final MovieRepo _movieRepo = MovieRepo();

  Movie? _movie;
  List<Cast> _cast = [];
  List<Review> _reviews = [];
  List<Video> _videos = [];
  List<Movie> _similar = [];
  bool _isLoading = false;
  String? _errorMessage;

  Movie? get movie => _movie;
  List<Cast> get cast => _cast;
  List<Review> get reviews => _reviews;
  List<Video> get videos => _videos;
  List<Movie> get similar => _similar;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Video? get trailer => _videos.isEmpty
      ? null
      : _videos.firstWhere(
          (v) => v.isTrailer && v.isYoutube,
          orElse: () => _videos.first,
        );

  int _currentReviewPage = 1;
  int _totalReviewPages = 1;
  bool _isLoadingMoreReviews = false;

  int get currentReviewPage => _currentReviewPage;
  int get totalReviewPages => _totalReviewPages;
  bool get isLoadingMoreReviews => _isLoadingMoreReviews;
  bool get hasMoreReviews => _currentReviewPage < _totalReviewPages;

  Future<void> loadMovieDetail(int movieId) async {
    _isLoading = true;
    _errorMessage = null;
    _currentReviewPage = 1;
    _totalReviewPages = 1;
    notifyListeners();

    try {
      final results = await Future.wait([
        _movieRepo.getMovieDetail(movieId),
        _movieRepo.getCredits(movieId),
        _movieRepo.getReviews(movieId),
        _movieRepo.getVideos(movieId),
        _movieRepo.getSimilar(movieId),
      ]);

      _movie = results[0] as Movie;
      _cast = results[1] as List<Cast>;
      _videos = results[3] as List<Video>;
      _similar = results[4] as List<Movie>;
      
      final reviewResponse = results[2] as ReviewResponse;
      _totalReviewPages = reviewResponse.totalPages;
      final tmdbReviews = reviewResponse.results;
      List<Review> localReviews = [];
      
      // Fetch local reviews separately to isolate Firestore errors
      try {
        localReviews = await _movieRepo.getLocalReviews(movieId);
      } catch (e) {
        debugPrint('Isolated Firestore error (local reviews): $e');
      }
      
      // Combine reviews, local ones first
      _reviews = [...localReviews, ...tmdbReviews];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreReviews() async {
    if (_movie == null || _isLoadingMoreReviews || !hasMoreReviews) return;
    
    _isLoadingMoreReviews = true;
    notifyListeners();

    try {
      _currentReviewPage++;
      final reviewResponse = await _movieRepo.getReviews(_movie!.id, page: _currentReviewPage);
      _reviews = [..._reviews, ...reviewResponse.results];
      _isLoadingMoreReviews = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMoreReviews = false;
      notifyListeners();
      // Don't show global error for load more
      debugPrint('Error loading more reviews: $e');
    }
  }

  Future<void> addReview(int movieId, Review review) async {
    final originalReviews = List<Review>.from(_reviews);
    try {
      // Optimistic update
      _reviews = [review, ..._reviews];
      notifyListeners();
      
      await _movieRepo.addReview(movieId, review);
    } catch (e) {
      debugPrint('Firestore write error (addReview): $e');
      // Revert on error
      _reviews = originalReviews;
      _errorMessage = 'Failed to add review: Permission Denied. Please check Firestore Rules.';
      notifyListeners();
    }
  }

  void clear() {
    _movie = null;
    _cast = [];
    _reviews = [];
    _videos = [];
    _similar = [];
    _errorMessage = null;
    notifyListeners();
  }
}
