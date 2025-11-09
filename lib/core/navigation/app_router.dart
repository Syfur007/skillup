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
import 'package:skillup/features/auth/providers/auth_state_provider.dart';

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
  // Watch auth state stream (Firebase persistent session)
  final authStateAsync = ref.watch(authStateChangesProvider);
  final onboardingCompleted = ref.watch(onboardingCompletedProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,

    // Error handling for unknown routes
    errorBuilder: (context, state) => ErrorScreen(error: state.error),

    // Global navigation guards (auth redirects, etc.)
    redirect: (context, state) {
      final matchedLocation = state.matchedLocation;

      // First, wait for onboarding check
      return onboardingCompleted.when(
        data: (isCompleted) {
          // Handle auth state
          return authStateAsync.when(
            data: (user) {
              final isSignedIn = user != null;

              // Priority 1: If onboarding is not completed, redirect to onboarding (unless already there)
              if (!isCompleted && matchedLocation != RoutePaths.onboarding) {
                return RoutePaths.onboarding;
              }

              // Priority 2: If onboarding is completed but not signed in
              if (isCompleted && !isSignedIn) {
                // Allow access to login and register screens
                const authPaths = [RoutePaths.login, RoutePaths.register];
                final isOnAuthPath = authPaths.any((path) => matchedLocation.startsWith(path));

                if (!isOnAuthPath) {
                  // Redirect from splash, onboarding, or any protected route to login
                  return RoutePaths.login;
                }

                // Already on auth screen, no redirect needed
                return null;
              }

              // Priority 3: If onboarding is completed AND user is signed in
              if (isCompleted && isSignedIn) {
                // Redirect from splash, onboarding, or auth screens to home
                const publicPaths = [RoutePaths.login, RoutePaths.register, RoutePaths.onboarding, '/splash'];
                final isOnPublicPath = publicPaths.any((path) => matchedLocation.startsWith(path));

                if (isOnPublicPath) {
                  return RoutePaths.home;
                }

                // Already on a protected route, no redirect needed
                return null;
              }

              // No redirect needed
              return null;
            },
            loading: () => '/splash',
            error: (err, stack) => '/error',
          );
        },
        loading: () => '/splash', // Show splash while checking onboarding
        error: (err, stack) => '/error', // Redirect to an error screen on failure
      );
    },

    // Compose routes from all features using centralized route definitions
    routes: [
      ...AuthRoutes.routes,

      // It's good practice to have explicit routes for splash and error screens
      GoRoute(
        path: '/splash',
        builder: (context, state) => const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    ],
  );
});

