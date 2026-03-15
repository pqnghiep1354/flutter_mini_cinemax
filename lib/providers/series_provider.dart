import 'package:flutter/material.dart';
import '../models/series.dart';
import '../models/season.dart';
import '../models/episode.dart';
import '../models/cast.dart';
import '../models/video.dart';
import '../repos/series_repo.dart';

class SeriesProvider extends ChangeNotifier {
  final SeriesRepo _seriesRepo = SeriesRepo();

  List<Series> _popularSeries = [];
  Series? _seriesDetail;
  List<Season> _seasons = [];
  List<Episode> _episodes = [];
  List<Cast> _cast = [];
  List<Video> _videos = [];
  int _selectedSeasonIndex = 0;
  bool _isLoading = false;
  bool _isLoadingEpisodes = false;
  String? _errorMessage;

  List<Series> get popularSeries => _popularSeries;
  Series? get seriesDetail => _seriesDetail;
  List<Season> get seasons => _seasons;
  List<Episode> get episodes => _episodes;
  List<Cast> get cast => _cast;
  List<Video> get videos => _videos;
  int get selectedSeasonIndex => _selectedSeasonIndex;
  bool get isLoading => _isLoading;
  bool get isLoadingEpisodes => _isLoadingEpisodes;
  String? get errorMessage => _errorMessage;

  Video? get trailer => _videos.isEmpty
      ? null
      : _videos.firstWhere(
          (v) => v.isTrailer && v.isYoutube,
          orElse: () => _videos.first,
        );

  Future<void> loadPopularSeries() async {
    if (_popularSeries.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _popularSeries = await _seriesRepo.getPopular();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSeriesDetail(int seriesId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _seriesRepo.getSeriesDetail(seriesId),
        _seriesRepo.getSeasons(seriesId),
        _seriesRepo.getCredits(seriesId),
        _seriesRepo.getVideos(seriesId),
      ]);

      _seriesDetail = results[0] as Series;
      _seasons = results[1] as List<Season>;
      _cast = results[2] as List<Cast>;
      _videos = results[3] as List<Video>;

      // Auto-load first season episodes
      if (_seasons.isNotEmpty) {
        await loadEpisodes(seriesId, _seasons.first.seasonNumber);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadEpisodes(int seriesId, int seasonNumber) async {
    _isLoadingEpisodes = true;
    notifyListeners();

    try {
      _episodes = await _seriesRepo.getSeasonEpisodes(seriesId, seasonNumber);
      _isLoadingEpisodes = false;
      notifyListeners();
    } catch (e) {
      _isLoadingEpisodes = false;
      notifyListeners();
    }
  }

  void selectSeason(int index, int seriesId) {
    _selectedSeasonIndex = index;
    if (_seasons.isNotEmpty) {
      loadEpisodes(seriesId, _seasons[index].seasonNumber);
    }
  }

  void clear() {
    _seriesDetail = null;
    _seasons = [];
    _episodes = [];
    _cast = [];
    _videos = [];
    _selectedSeasonIndex = 0;
    _errorMessage = null;
    notifyListeners();
  }
}
