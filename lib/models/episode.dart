class Episode {
  final int id;
  final String name;
  final String? overview;
  final String? stillPath;
  final int episodeNumber;
  final int seasonNumber;
  final double voteAverage;
  final String? airDate;
  final int runtime;

  Episode({
    required this.id,
    required this.name,
    this.overview,
    this.stillPath,
    required this.episodeNumber,
    required this.seasonNumber,
    this.voteAverage = 0.0,
    this.airDate,
    this.runtime = 0,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      overview: json['overview'],
      stillPath: json['still_path'],
      episodeNumber: json['episode_number'] ?? 0,
      seasonNumber: json['season_number'] ?? 0,
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      airDate: json['air_date'],
      runtime: json['runtime'] ?? 0,
    );
  }

  String get fullStillPath =>
      stillPath != null ? 'https://image.tmdb.org/t/p/w342$stillPath' : '';

  String get runtimeFormatted {
    if (runtime == 0) return '';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }
}
