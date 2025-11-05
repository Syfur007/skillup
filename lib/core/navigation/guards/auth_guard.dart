// Core: Route protection based on auth state (placeholder)

class AuthGuard {
  /// Placeholder guard that should be wired to the router to block access
  /// when the user is not authenticated.
  ///
  /// Returns true when navigation is allowed.
  Future<bool> canActivate() async {
    // TODO: Read auth state from provider / repository
    return false;
  }
}
