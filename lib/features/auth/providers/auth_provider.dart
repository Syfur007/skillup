// auth_provider.dart
// State management provider for authentication (e.g., login state, user info).
// Choose your preferred state solution (Riverpod, Provider, Bloc) and wire it.

import 'package:skillup/data/repositories/auth_repository_impl.dart';
import 'package:skillup/domain/repositories/auth_repository.dart';

class AuthProvider {
  final AuthRepository _authRepository;

  AuthProvider({AuthRepository? authRepository}) : _authRepository = authRepository ?? AuthRepositoryImpl();

  // Register a new user
  Future<void> register(String email, String password) async {
    await _authRepository.signUp(email, password);
  }

  // Sign in existing user with email/password
  Future<void> signIn(String email, String password) async {
    await _authRepository.signInWithEmail(email, password);
  }

  // Sign out
  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  // Send password reset email
  Future<void> resetPassword(String email) async {
    await _authRepository.resetPassword(email);
  }

  // Validation methods
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Allow word chars, dot and dash in the local part
    final emailRegex = RegExp(r'^((?!\.)[\w\-_.]*[^.])(@\w+)(\.\w+(\.\w+)?[^.\W])$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }
}
