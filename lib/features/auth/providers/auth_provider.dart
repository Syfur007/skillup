// auth_provider.dart
// State management provider for authentication (e.g., login state, user info).
// Choose your preferred state solution (Riverpod, Provider, Bloc) and wire it.

import 'package:skillup/data/repositories/auth_repository_impl.dart';
import 'package:skillup/domain/repositories/auth_repository.dart';

class AuthProvider {
  final AuthRepository _authRepository;

  AuthProvider({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepositoryImpl();

  // Register a new user
  Future<void> register(String email, String password) async {
    await _authRepository.signUp(email, password);
  }

  // Validation methods
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Allow word chars, dot and dash in the local part
    final emailRegex = RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$');

    // The above construct ensures no redundant escapes while keeping the pattern intact.

    // However, to keep it simple and avoid escaping confusion, use a clearer literal:
    // final emailRegex = RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$');

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
