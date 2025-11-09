// auth_state_provider.dart
// Provides the Firebase authentication state stream as a Riverpod StreamProvider.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillup/data/repositories/auth_repository_impl.dart';

/// Stream provider that emits the current Firebase [User] or null.
final authStateChangesProvider = StreamProvider<User?>((ref) {
  // Use the repository which wraps FirebaseAuth for consistency with the codebase.
  return AuthRepositoryImpl().authStateChanges;
});
