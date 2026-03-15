class Review {
  final String id;
  final String author;
  final String? avatarPath;
  final double? rating;
  final String content;
  final String createdAt;

  Review({
    required this.id,
    required this.author,
    this.avatarPath,
    this.rating,
    required this.content,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    final authorDetails = json['author_details'] ?? {};
    return Review(
      id: json['id'] ?? '',
      author: json['author'] ?? '',
      avatarPath: authorDetails['avatar_path'],
      rating: authorDetails['rating'] != null
          ? (authorDetails['rating'] as num).toDouble()
          : null,
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  factory Review.fromFirestore(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      author: json['author'] ?? '',
      avatarPath: json['avatar_path'],
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'author': author,
      'avatar_path': avatarPath,
      'rating': rating,
      'content': content,
      'created_at': createdAt,
    };
  }

  String get fullAvatarPath {
    if (avatarPath == null) return '';
    if (avatarPath!.startsWith('/https')) {
      return avatarPath!.substring(1);
    }
    return 'https://image.tmdb.org/t/p/w185$avatarPath';
  }
}
