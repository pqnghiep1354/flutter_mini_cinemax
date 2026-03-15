import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/app_constants.dart';
import '../models/user_profile.dart';

class UserRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---- User Profile ----

  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();
    if (!doc.exists) return null;
    return UserProfile.fromFirestore(doc.data()!, docId: doc.id);
  }

  Future<void> createUserProfile(UserProfile profile) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(profile.uid)
        .set(profile.toFirestore());
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(profile.uid)
        .set(profile.toFirestore(), SetOptions(merge: true));
  }

  // ---- Favorites ----

  Future<void> addToFavorites(String uid, int movieId) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .set({
      'favorite_movie_ids': FieldValue.arrayUnion([movieId]),
    }, SetOptions(merge: true));
  }

  Future<void> removeFromFavorites(String uid, int movieId) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .set({
      'favorite_movie_ids': FieldValue.arrayRemove([movieId]),
    }, SetOptions(merge: true));
  }

  // ---- My List / Watchlist ----

  Future<void> addToMyList(String uid, int movieId) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .set({
      'my_list_movie_ids': FieldValue.arrayUnion([movieId]),
    }, SetOptions(merge: true));
  }

  Future<void> removeFromMyList(String uid, int movieId) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .set({
      'my_list_movie_ids': FieldValue.arrayRemove([movieId]),
    }, SetOptions(merge: true));
  }

  // ---- Reviews ----

  Future<void> addReview({
    required int movieId,
    required String uid,
    required String author,
    required String content,
    required double rating,
  }) async {
    final reviewDoc = _firestore
        .collection(AppConstants.reviewsCollection)
        .doc();

    await reviewDoc.set({
      'id': reviewDoc.id,
      'movie_id': movieId,
      'uid': uid,
      'author': author,
      'content': content,
      'rating': rating,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getMovieReviews(int movieId) async {
    final snapshot = await _firestore
        .collection(AppConstants.reviewsCollection)
        .where('movie_id', isEqualTo: movieId)
        .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // ---- Notifications ----

  Future<void> saveFcmToken(String uid, String token) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .set({
      'fcm_token': token,
      'updated_at': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }
}
