// app_router.dart
// Main router composition that imports route definitions from centralized location.
// This file now just composes routes rather than defining them directly.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import 'error_screen.dart';
import 'routes/auth_routes.dart';

/// Main router provider that composes all feature routes.
///
/// This provider can be watched by the app to react to auth state changes.
/// All routes are centralized in the core/navigation/routes directory.
final routerProvider = Provider<GoRouter>((ref) {
  // TODO: Watch auth state when auth provider is ready
  // final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: RoutePaths.onboarding,
    debugLogDiagnostics: true,

    // Error handling for unknown routes
    errorBuilder: (context, state) => ErrorScreen(error: state.error),

    // Global navigation guards (auth redirects, etc.)
    redirect: (context, state) {
      // TODO: Implement auth-based redirects when auth provider is ready
      // return _handleAuthRedirect(state.matchedLocation, authState);
      return null;
    },

    // Compose routes from all features using centralized route definitions
    routes: [
      ...AuthRoutes.routes,
      // ...DashboardRoutes.routes,
      // ...ExploreRoutes.routes,
      // ...GroupsRoutes.routes,
      // ...ProfileRoutes.routes,
    ],
  );
});

/// Helper function for authentication-based redirects.
///
/// Uncomment and use when auth provider is implemented.
// String? _handleAuthRedirect(String location, AuthState authState) {
//   const publicPaths = ['/login', '/register'];
//   final isPublicPath = publicPaths.any((path) => location.startsWith(path));
//   final isAuthenticated = authState.isAuthenticated;
//
//   // Redirect to login if not authenticated and trying to access protected route
//   if (!isAuthenticated && !isPublicPath) {
//     return RoutePaths.login;
//   }
//
//   // Redirect to home if authenticated and trying to access login/register
//   if (isAuthenticated && isPublicPath) {
//     return RoutePaths.dashboard;
//   }
//
//   return null;
// }
