// navigation.dart
// Central export file for navigation-related functionality.
// Import this file to access all navigation tools in one go.

// Core navigation exports
export 'app_router.dart';
export 'route_names.dart';
export 'navigation_extensions.dart';
export 'error_screen.dart';

// Route definitions exports
export 'routes/auth_routes.dart';

/// Quick reference for navigation usage:
///
/// 1. Basic navigation:
///    context.goToNamed(RouteNames.login);
///
/// 2. Navigation with parameters:
///    context.goToNamed(
///      RouteNames.roadmapDetail,
///      pathParameters: {'id': 'roadmap-123'},
///    );
///
/// 3. Navigation with query parameters:
///    context.goToNamed(
///      RouteNames.explore,
///      queryParameters: {'filter': 'popular'},
///    );
///
/// 4. Go back:
///    context.popRoute();
///
/// 5. Check if can go back:
///    if (context.canPop()) { ... }
