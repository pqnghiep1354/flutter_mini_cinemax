class Cast {
  final int id;
  final String name;
  final String? profilePath;
  final String? character;
  final String? department;
  final int order;

  Cast({
    required this.id,
    required this.name,
    this.profilePath,
    this.character,
    this.department,
    this.order = 0,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      profilePath: json['profile_path'],
      character: json['character'],
      department: json['known_for_department'],
      order: json['order'] ?? 0,
    );
  }

  String get fullProfilePath =>
      profilePath != null ? 'https://image.tmdb.org/t/p/w185$profilePath' : '';
}
