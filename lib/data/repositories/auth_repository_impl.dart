// Data layer: Firebase implementation of AuthRepository (placeholder)

import 'package:skillup/domain/repositories/auth_repository.dart';

class FirebaseAuthRepositoryImpl implements AuthRepository {
  // TODO: Inject FirebaseAuth, GoogleSignIn, etc. when implementing

  @override
  Future<String?> getToken() async {
    // Placeholder - should return token string in a real implementation
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<bool> isSignedIn() async {
    // Placeholder
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    // Placeholder
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<void> signInWithGitHub() async {
    // Placeholder
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<void> signInWithGoogle() async {
    // Placeholder
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    // Placeholder
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<void> signUp(String email, String password) async {
    // Placeholder
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword(String email) {
    // TODO: implement
    throw UnimplementedError();
  }
}

