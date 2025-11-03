// auth_routes.dart
// Centralized route definitions for auth feature.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillup/core/navigation/route_names.dart';

import 'package:skillup/features/auth/screens/login_screen.dart';
import 'package:skillup/features/auth/screens/onboarding_screen.dart';
import 'package:skillup/features/auth/screens/registration_screen.dart';
import 'package:skillup/features/dashboard/screens/dashboard_screen.dart';

/// Authentication feature routes
class AuthRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: RoutePaths.login,
      name: RouteNames.login,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const LoginScreen()),
    ),
    GoRoute(
      path: RoutePaths.register,
      name: RouteNames.register,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const RegistrationScreen()),
    ),
    GoRoute(
      path: RoutePaths.onboarding,
      name: RouteNames.onboarding,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const OnboardingScreen()),
    ),
    GoRoute(
      path: RoutePaths.dashboard,
      name: RouteNames.dashboard,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const DashboardScreen()),
    ),
  ];
}
