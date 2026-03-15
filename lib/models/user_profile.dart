class UserProfile {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final String? phoneNumber;
  final String? gender;
  final DateTime? createdAt;
  final List<int> favoriteMovieIds;
  final List<int> myListMovieIds;

  UserProfile({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
    this.phoneNumber,
    this.gender,
    this.createdAt,
    this.favoriteMovieIds = const [],
    this.myListMovieIds = const [],
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> json, {String? docId}) {
    return UserProfile(
      uid: json['uid'] ?? docId ?? '',
      displayName: json['display_name'],
      email: json['email'],
      photoUrl: json['photo_url'],
      phoneNumber: json['phone_number'],
      gender: json['gender'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      favoriteMovieIds: json['favorite_movie_ids'] != null
          ? List<int>.from(json['favorite_movie_ids'])
          : [],
      myListMovieIds: json['my_list_movie_ids'] != null
          ? List<int>.from(json['my_list_movie_ids'])
          : [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'display_name': displayName,
      'email': email,
      'photo_url': photoUrl,
      'phone_number': phoneNumber,
      'gender': gender,
      'created_at': createdAt?.toIso8601String(),
      'favorite_movie_ids': favoriteMovieIds,
      'my_list_movie_ids': myListMovieIds,
    };
  }

  UserProfile copyWith({
    String? displayName,
    String? email,
    String? photoUrl,
    String? phoneNumber,
    String? gender,
    List<int>? favoriteMovieIds,
    List<int>? myListMovieIds,
  }) {
    return UserProfile(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      createdAt: createdAt,
      favoriteMovieIds: favoriteMovieIds ?? this.favoriteMovieIds,
      myListMovieIds: myListMovieIds ?? this.myListMovieIds,
    );
  }
}
