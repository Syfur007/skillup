// route_names.dart
// Centralized route names and paths to avoid string literals across the app.
// This prevents typos and makes refactoring easier.

/// Route names used with GoRouter's named navigation
class RouteNames {

  // Core routes
  static const home = 'home';
  static const error = 'error';
  static const splash = 'splash';
  static const onboarding = 'onboarding';

  // Auth routes
  static const login = 'login';
  static const register = 'register';
  static const resetPassword = 'reset-password';

  // Dashboard routes
  static const dashboard = 'dashboard';

  // Explore routes
  static const explore = 'explore';
  static const roadmapList = 'roadmap-list';
  static const roadmapDetail = 'roadmap-detail';
  static const createRoadmap = 'create-roadmap';

  // Groups routes
  static const groups = 'groups';

  // Profile routes
  static const profile = 'profile';
  static const profileSetup = 'profile-setup';

  // Home routes
}

/// Route paths - kept separate from names for flexibility
class RoutePaths {

  // Core paths
  static const home = '/home';
  static const error = '/error';
  static const splash = '/splash';
  static const onboarding = '/onboarding';

  // Auth paths
  static const login = '/login';
  static const register = '/register';
  static const resetPassword = '/reset-password';

  // Dashboard paths
  static const dashboard = '/';

  // Explore paths
  static const explore = '/explore';
  static const roadmapList = '/explore/roadmaps';
  static const roadmapDetail = '/explore/roadmaps/:id';
  static const createRoadmap = '/create-roadmap';

  // Groups paths
  static const groups = '/groups';

  // Profile paths
  static const profile = '/profile';
  static const profileSetup = '/profile-setup';


  // Helper methods for dynamic paths
  static String roadmapDetailPath(String id) => '/explore/roadmaps/$id';
}
