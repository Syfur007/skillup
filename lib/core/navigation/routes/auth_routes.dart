// auth_routes.dart
// Centralized route definitions for auth feature.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillup/core/navigation/route_names.dart';

import 'package:skillup/features/auth/screens/login_screen.dart';
import 'package:skillup/features/auth/screens/onboarding_screen.dart';
import 'package:skillup/features/auth/screens/registration_screen.dart';
import 'package:skillup/features/dashboard/screens/dashboard_screen.dart';
import 'package:skillup/features/explore/screens/roadmap_list_screen.dart';
import 'package:skillup/features/explore/screens/roadmap_detail_screen.dart';
import 'package:skillup/features/explore/screens/create_roadmap_screen.dart';
import 'package:skillup/features/home/screens/home_screen.dart';
import 'package:skillup/features/profile/screens/profile_screen.dart';
import 'package:skillup/features/explore/models/roadmap.dart';

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
    GoRoute(
      path: RoutePaths.profile,
      name: RouteNames.profile,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const ProfileScreen()),
    ),
    GoRoute(
      path: RoutePaths.roadmapList,
      name: RouteNames.roadmapList,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const RoadmapListScreen()),
    ),
    GoRoute(
      path: RoutePaths.createRoadmap,
      name: RouteNames.createRoadmap,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const CreateRoadmapScreen()),
    ),
    GoRoute(
      path: RoutePaths.roadmapDetail,
      name: RouteNames.roadmapDetail,
      pageBuilder: (context, state) {
        final extra = state.extra;
        if (extra is Roadmap) {
          return MaterialPage(
            key: state.pageKey,
            child: RoadmapDetailScreen(roadmap: extra),
          );
        }

        return MaterialPage(
          key: state.pageKey,
          child: Scaffold(
            appBar: AppBar(title: const Text('Roadmap')),
            body: const Center(child: Text('Roadmap not found')),
          ),
        );
      },
    ),
    GoRoute(
      path: RoutePaths.home,
      name: RouteNames.home,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const HomeScreen()),
    ),
  ];
}
