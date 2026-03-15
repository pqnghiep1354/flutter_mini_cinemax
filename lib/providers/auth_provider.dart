import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import '../repos/auth_repo.dart';
import '../repos/user_repo.dart';
import '../services/notification_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();
  final UserRepo _userRepo = UserRepo();

  User? _user;
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;
  bool _initialized = false;
  bool _isGuest = false;

  User? get user => _user;
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;
  bool get isGuest => _isGuest;
  bool get isInitialized => _initialized;

  void setGuestMode(bool value) {
    _isGuest = value;
    notifyListeners();
  }

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _user = _authRepo.currentUser;
    _initialized = true;
    notifyListeners();

    // Listen for future auth changes
    _authRepo.authStateChanges.listen((user) {
      _user = user;
      if (user != null) {
        _isGuest = false;
        _loadUserProfile();
        _updateFcmToken();
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserProfile() async {
    if (_user == null) return;
    try {
      _userProfile = await _userRepo.getUserProfile(_user!.uid);
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }

  Future<bool> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _authRepo.signUpWithEmail(
        email: email,
        password: password,
      );

      await _authRepo.updateDisplayName(name);

      final profile = UserProfile(
        uid: credential.user!.uid,
        displayName: name,
        email: email,
        createdAt: DateTime.now(),
      );
      await _userRepo.createUserProfile(profile);
      _userProfile = profile;
      _user = credential.user;

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _authRepo.signInWithEmail(
        email: email,
        password: password,
      );
      _user = credential.user;

      // Ensure specific profile existence
      final existing = await _userRepo.getUserProfile(_user!.uid);
      if (existing == null) {
        final profile = UserProfile(
          uid: _user!.uid,
          displayName: _user!.displayName,
          email: _user!.email,
          createdAt: DateTime.now(),
        );
        await _userRepo.createUserProfile(profile);
        _userProfile = profile;
      } else {
        _userProfile = existing;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _authRepo.signInWithGoogle();
      if (credential == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _user = credential.user;

      final existing = await _userRepo.getUserProfile(_user!.uid);
      if (existing == null) {
        final profile = UserProfile(
          uid: _user!.uid,
          displayName: _user!.displayName,
          email: _user!.email,
          photoUrl: _user!.photoURL,
          createdAt: DateTime.now(),
        );
        await _userRepo.createUserProfile(profile);
        _userProfile = profile;
      } else {
        _userProfile = existing;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Google sign-in failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authRepo.signOut();
    _user = null;
    _userProfile = null;
    notifyListeners();
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Re-authenticate user first (required by Firebase for security sensitive actions)
      await _authRepo.reauthenticate(currentPassword);
      
      // Update password
      await _authRepo.updatePassword(newPassword);

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepo.resetPassword(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many requests. Please try again later';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        debugPrint('Firebase Auth Error Code: $code');
        return 'An error occurred. Please try again';
    }
  }

  Future<void> _updateFcmToken() async {
    if (_user == null) return;
    final token = await NotificationService.instance.getToken();
    if (token != null) {
      await _userRepo.saveFcmToken(_user!.uid, token);
    }
  }
}
