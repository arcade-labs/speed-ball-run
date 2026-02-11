import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart' show AuthService, AuthCancelledException;

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  User? _user;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<User?>? _authSub;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService() {
    _authSub = _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userId => _user?.uid;

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signInWithGoogle();
    } on AuthCancelledException {
      // User cancelled — not an error, just do nothing
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      _error = 'Sign in failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithApple() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signInWithApple();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool get isAppleSignInAvailable => _authService.isAppleSignInAvailable;

  Future<void> signOut() async {
    await _authService.signOut();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
