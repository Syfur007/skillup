// core_routes.dart
// Centralized route definitions for core feature.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillup/core/navigation/route_names.dart';

import 'package:skillup/features/auth/screens/onboarding_screen.dart';
import 'package:skillup/features/home/screens/home_screen.dart';

/// Core feature routes
class CoreRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: RoutePaths.splash,
      name: RouteNames.splash,
      builder: (context, state) => const Scaffold(body: Center(child: CircularProgressIndicator())),
    ),
    GoRoute(
      path: RoutePaths.onboarding,
      name: RouteNames.onboarding,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const OnboardingScreen()),
    ),
    GoRoute(
      path: RoutePaths.home,
      name: RouteNames.home,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const HomeScreen()),
    ),

  ];
}