import '../models/series.dart';
import '../models/season.dart';
import '../models/episode.dart';
import '../models/cast.dart';
import '../models/video.dart';
import 'tmdb_api_service.dart';

class SeriesRepo {
  final TmdbApiService _api = TmdbApiService();

  Future<List<Series>> getPopular({int page = 1}) async {
    final response = await _api.get(
      '/tv/popular',
      queryParameters: {'page': page},
    );
    final results = response.data['results'] as List;
    return results.map((json) => Series.fromJson(json)).toList();
  }

  Future<List<Series>> getTopRated({int page = 1}) async {
    final response = await _api.get(
      '/tv/top_rated',
      queryParameters: {'page': page},
    );
    final results = response.data['results'] as List;
    return results.map((json) => Series.fromJson(json)).toList();
  }

  Future<List<Series>> getTrending({int page = 1}) async {
    final response = await _api.get(
      '/trending/tv/week',
      queryParameters: {'page': page},
    );
    final results = response.data['results'] as List;
    return results.map((json) => Series.fromJson(json)).toList();
  }

  Future<Series> getSeriesDetail(int seriesId) async {
    final response = await _api.get('/tv/$seriesId');
    return Series.fromJson(response.data);
  }

  Future<List<Season>> getSeasons(int seriesId) async {
    final response = await _api.get('/tv/$seriesId');
    final seasons = response.data['seasons'] as List? ?? [];
    return seasons.map((json) => Season.fromJson(json)).toList();
  }

  Future<List<Episode>> getSeasonEpisodes(int seriesId, int seasonNumber) async {
    final response = await _api.get('/tv/$seriesId/season/$seasonNumber');
    final episodes = response.data['episodes'] as List? ?? [];
    return episodes.map((json) => Episode.fromJson(json)).toList();
  }

  Future<List<Cast>> getCredits(int seriesId) async {
    final response = await _api.get('/tv/$seriesId/credits');
    final cast = response.data['cast'] as List;
    return cast.map((json) => Cast.fromJson(json)).toList();
  }

  Future<List<Video>> getVideos(int seriesId) async {
    final response = await _api.get('/tv/$seriesId/videos');
    final results = response.data['results'] as List;
    return results.map((json) => Video.fromJson(json)).toList();
  }
}
