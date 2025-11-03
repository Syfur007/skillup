// Domain layer: Authentication repository interface

abstract class AuthRepository {
  /// Sign in with email and password
  Future<void> signInWithEmail(String email, String password);

  /// Register a new user with email and password
  Future<void> signUp(String email, String password);

  /// Reset password
  Future<void> resetPassword(String email);

  /// Sign in with Google
  Future<void> signInWithGoogle();

  /// Sign in with GitHub
  Future<void> signInWithGitHub();

  /// Sign out the current user
  Future<void> signOut();

  /// Returns true when a user is currently signed in
  Future<bool> isSignedIn();

  /// Returns an optional JWT or session token if available
  Future<String?> getToken();
}

