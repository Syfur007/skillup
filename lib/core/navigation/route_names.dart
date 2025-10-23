// route_names.dart
// Centralized route names and paths to avoid string literals across the app.
// This prevents typos and makes refactoring easier.

/// Route names used with GoRouter's named navigation
class RouteNames {
  // Auth routes
  static const login = 'login';
  static const register = 'register';
  static const profileSetup = 'profile-setup';
  static const resetPassword = 'reset-password';

  // Dashboard routes
  static const dashboard = 'dashboard';
  
  // Explore routes
  static const explore = 'explore';
  static const roadmapList = 'roadmap-list';
  static const roadmapDetail = 'roadmap-detail';
  
  // Groups routes
  static const groups = 'groups';
  
  // Profile routes
  static const profile = 'profile';
}

/// Route paths - kept separate from names for flexibility
class RoutePaths {
  // Auth paths
  static const login = '/login';
  static const register = '/register';
  static const profileSetup = '/profile-setup';
  static const resetPassword = '/reset-password';
  
  // Dashboard paths
  static const dashboard = '/';
  
  // Explore paths
  static const explore = '/explore';
  static const roadmapList = '/explore/roadmaps';
  static const roadmapDetail = '/explore/roadmaps/:id';
  
  // Groups paths
  static const groups = '/groups';
  
  // Profile paths
  static const profile = '/profile';
  
  // Helper methods for dynamic paths
  static String roadmapDetailPath(String id) => '/explore/roadmaps/$id';
}
