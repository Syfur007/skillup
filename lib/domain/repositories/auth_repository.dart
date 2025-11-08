// Domain layer: Authentication repository interface

import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  /// Sign in with email and password
  Future<void> signInWithEmail(String email, String password);

  /// Sign in with Google
  Future<void> signInWithGoogle();

  /// Sign in with GitHub
  Future<void> signInWithGitHub();

  /// Register a new user with email and password
  Future<void> signUp(String email, String password);

  /// Reset password
  Future<void> resetPassword(String email);

  /// Sign out the current user
  Future<void> signOut();

  /// Returns true when a user is currently signed in
  Future<bool> isSignedIn();

  /// Stream that monitors the authentication state of the user.
  /// Firebase handles the persistent session and streams the current user (or null).
  Stream<User?> get authStateChanges;


}

