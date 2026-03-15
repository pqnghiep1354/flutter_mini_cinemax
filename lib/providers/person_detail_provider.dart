import 'package:flutter/material.dart';
import '../models/person.dart';
import '../models/movie.dart';
import '../repos/movie_repo.dart';

class PersonDetailProvider extends ChangeNotifier {
  final MovieRepo _movieRepo;

  PersonDetailProvider({MovieRepo? movieRepo}) : _movieRepo = movieRepo ?? MovieRepo();

  Person? _person;
  List<Movie> _movieCredits = [];
  bool _isLoading = false;
  String? _errorMessage;

  Person? get person => _person;
  List<Movie> get movieCredits => _movieCredits;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadPersonDetail(int personId) async {
    _isLoading = true;
    _errorMessage = null;
    _person = null;
    _movieCredits = [];
    notifyListeners();

    try {
      final detailJson = await _movieRepo.getPersonDetail(personId);
      _person = Person.fromJson(detailJson);
      _movieCredits = await _movieRepo.getPersonMovieCredits(personId);
      
      // Sort by popularity or release date if needed
      _movieCredits.sort((a, b) => b.popularity.compareTo(a.popularity));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
