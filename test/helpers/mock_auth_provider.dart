import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import 'package:speed_ball_run/providers/auth_provider.dart' as app;

/// A mock AuthProvider that doesn't require Firebase initialization.
/// Used in widget tests where we just need to satisfy the Provider dependency.
class MockAuthProvider with ChangeNotifier implements app.AuthProvider {
  @override
  bool get isAuthenticated => true;

  @override
  String? get userId => 'test-user';

  @override
  bool get isLoading => false;

  @override
  String? get error => null;

  @override
  bool get isAppleSignInAvailable => false;

  @override
  User? get user => null;

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signInWithApple() async {}

  @override
  Future<void> signOut() async {}

  @override
  void clearError() {}
}
