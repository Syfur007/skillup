// Feature: Auth state definitions

class AuthState {
  final AuthStatus status;
  final String? userId;

  const AuthState._(this.status, this.userId);

  const AuthState.unknown() : this._(AuthStatus.unknown, null);
  const AuthState.loading() : this._(AuthStatus.loading, null);
  const AuthState.authenticated(String userId) : this._(AuthStatus.authenticated, userId);
  const AuthState.unauthenticated() : this._(AuthStatus.unauthenticated, null);
}

enum AuthStatus { unknown, loading, authenticated, unauthenticated }
