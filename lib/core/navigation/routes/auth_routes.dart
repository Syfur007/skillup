// auth_routes.dart
// Route definitions for auth features.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillup/core/navigation/route_names.dart';

import 'package:skillup/features/auth/screens/login_screen.dart';
import 'package:skillup/features/auth/screens/registration_screen.dart';
import 'package:skillup/features/auth/screens/profile_setup_screen.dart';

/// Authentication feature routes
class AuthRoutes {
  static List<RouteBase> get routes => [
        GoRoute(
          path: RoutePaths.login,
          name: RouteNames.login,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const LoginScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.register,
          name: RouteNames.register,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const RegistrationScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.profileSetup,
          name: RouteNames.profileSetup,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const ProfileSetupScreen(),
          ),
        ),
      ];
}
