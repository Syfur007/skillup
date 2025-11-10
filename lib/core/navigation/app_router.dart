// app_router.dart
// Main router composition that imports route definitions from centralized location.
// This file now just composes routes rather than defining them directly.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'route_names.dart';
import 'error_screen.dart';
import 'package:skillup/core/navigation/routes/auth_routes.dart';
import 'package:skillup/core/navigation/routes/core_routes.dart';
import 'package:skillup/core/navigation/routes/explore_routes.dart';
import 'package:skillup/core/navigation/routes/profile_routes.dart';
import 'package:skillup/features/auth/providers/auth_state_provider.dart';
import 'package:skillup/data/repositories/auth_repository_impl.dart';

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

  // Create a refresh notifier that notifies GoRouter when auth state changes.
  // Some Riverpod versions don't expose `.stream` on the provider object, so read the stream directly from the repository.
  final authStream = AuthRepositoryImpl().authStateChanges;
  final refreshListenable = GoRouterRefreshStream(authStream);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    refreshListenable: refreshListenable,

    // Error handling for unknown routes
    errorBuilder: (context, state) => ErrorScreen(error: state.error),

    // Global navigation guards (auth redirects, etc.)
    redirect: (context, state) {
      final currentLocation = state.matchedLocation;

      // First, wait for onboarding check
      return onboardingCompleted.when(
        data: (isCompleted) {
          return authStateAsync.when(
            data: (user) {
              final isSignedIn = user != null;

              // If onboarding not completed -> force onboarding
              if (!isCompleted && currentLocation != RoutePaths.onboarding) {
                return RoutePaths.onboarding;
              }

              // If onboarding completed but not signed in -> allow only auth screens
              if (isCompleted && !isSignedIn) {
                const allowed = [RoutePaths.login, RoutePaths.register];
                final onAllowed = allowed.any((p) => currentLocation.startsWith(p));
                if (!onAllowed) return RoutePaths.login;
                return null;
              }

              // If signed in and onboarding completed -> avoid public auth/onboarding/splash
              if (isCompleted && isSignedIn) {
                const publicPaths = [RoutePaths.login, RoutePaths.register, RoutePaths.onboarding, RoutePaths.splash];
                final onPublic = publicPaths.any((p) => currentLocation.startsWith(p));
                if (onPublic) return RoutePaths.home;
                return null;
              }

              return null;
            },
            loading: () => RoutePaths.splash,
            error: (err, stack) => RoutePaths.error,
          );
        },
        loading: () => RoutePaths.splash,
        error: (err, stack) => RoutePaths.error,
      );
    },

    // Compose routes from all features using centralized route definitions
    routes: [
      ...CoreRoutes.routes,
      ...AuthRoutes.routes,
      ...ExploreRoutes.routes,
      ...ProfileRoutes.routes,
    ],
  );
});

/// Helper that converts a [Stream] into a [ChangeNotifier] so `GoRouter` can
/// listen and refresh whenever the stream emits (used for auth state changes).
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _sub;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
