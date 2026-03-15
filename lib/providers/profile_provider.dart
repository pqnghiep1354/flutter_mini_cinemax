import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../repos/user_repo.dart';

class ProfileProvider extends ChangeNotifier {
  final UserRepo _userRepo = UserRepo();

  UserProfile? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProfile(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      _profile = await _userRepo.getUserProfile(uid);
      _errorMessage = null;
    } catch (e) {
      debugPrint('Isolated Firestore error (loadProfile): $e');
      // Do not set _errorMessage for profile load failure to allow app usage
      // _errorMessage = e.toString(); 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String uid,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? gender,
    String? email,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = (_profile ?? UserProfile(uid: uid, email: email, createdAt: DateTime.now())).copyWith(
        displayName: displayName,
        email: email,
        photoUrl: photoUrl,
        phoneNumber: phoneNumber,
        gender: gender,
      );

      await _userRepo.updateUserProfile(updated);
      _profile = updated;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void setProfile(UserProfile? profile) {
    _profile = profile;
    notifyListeners();
  }
}
