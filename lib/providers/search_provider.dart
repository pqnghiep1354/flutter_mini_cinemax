import 'dart:async';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../repos/search_repo.dart';

class SearchProvider extends ChangeNotifier {
  final SearchRepo _searchRepo = SearchRepo();

  List<Movie> _results = [];
  String _query = '';
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _debounce;

  List<Movie> get results => _results;
  String get query => _query;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasResults => _results.isNotEmpty;
  bool get isEmptySearch => _query.isNotEmpty && _results.isEmpty && !_isLoading;

  void onSearchChanged(String value) {
    _query = value;
    _debounce?.cancel();

    if (value.isEmpty) {
      _results = [];
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(value);
    });
  }

  Future<void> _performSearch(String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _results = await _searchRepo.multiSearch(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _query = '';
    _results = [];
    _debounce?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
