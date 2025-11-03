// app_router.dart
// Main router composition that imports route definitions from centralized location.
// This file now just composes routes rather than defining them directly.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'route_names.dart';
import 'error_screen.dart';
import 'routes/auth_routes.dart';

/// Provider to determine if onboarding has been completed.
/// It asynchronously checks SharedPreferences.
final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  // Return false if the key doesn't exist, meaning onboarding is not completed.
  return prefs.getBool('onboardingCompleted') ?? false;
});

/// Main router provider that composes all feature routes.
///
/// This provider can be watched by the app to react to auth state changes.
/// All routes are centralized in the core/navigation/routes directory.
final routerProvider = Provider<GoRouter>((ref) {
  // TODO: Watch auth state when auth provider is ready
  // final authState = ref.watch(authStateProvider);
  final onboardingCompleted = ref.watch(onboardingCompletedProvider);

  return GoRouter(
    initialLocation: RoutePaths.onboarding,
    debugLogDiagnostics: true,

    // Error handling for unknown routes
    errorBuilder: (context, state) => ErrorScreen(error: state.error),

    // Global navigation guards (auth redirects, etc.)
    redirect: (context, state) {
      final matchedLocation = state.matchedLocation;

      // Use the result of the future provider. While loading, show a splash/loading screen.
      return onboardingCompleted.when(
        data: (isCompleted) {
          // If onboarding is not completed, and we are not on the onboarding path, redirect to it.
          if (!isCompleted && matchedLocation != RoutePaths.onboarding) {
            return RoutePaths.onboarding;
          }
          // If onboarding is completed and the user is at the root/onboarding path, redirect to the dashboard.
          if (isCompleted && matchedLocation == RoutePaths.onboarding) {
            return RoutePaths.dashboard; // Assumes a '/dashboard' route exists
          }

          // TODO: Add auth-based redirects here when ready
          // return _handleAuthRedirect(state.matchedLocation, authState);

          // No redirect needed, continue to the requested route.
          return null;
        },
        // Show a loading indicator while checking the onboarding status.
        loading: () => '/splash', // You should create a simple splash screen for this route
        error: (err, stack) => '/error', // Redirect to an error screen on failure
      );
    },

    // Compose routes from all features using centralized route definitions
    routes: [
      ...AuthRoutes.routes,
      // ...DashboardRoutes.routes,
      // ...ExploreRoutes.routes,
      // ...GroupsRoutes.routes,
      // ...ProfileRoutes.routes,

      // It's good practice to have explicit routes for splash and error screens
      GoRoute(
        path: '/splash',
        builder: (context, state) => const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
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
