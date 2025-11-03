// Data layer: Local storage datasource for authentication persistence

abstract class AuthLocalDataSource {
  /// Persist an auth token (e.g. JWT) locally
  Future<void> persistToken(String token);

  /// Read the persisted auth token, or null if none
  Future<String?> readToken();

  /// Clear any persisted auth data
  Future<void> clearToken();
}
