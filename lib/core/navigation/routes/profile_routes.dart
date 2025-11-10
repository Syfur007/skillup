// profile_routes.dart
// Centralized route definitions for profile feature.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillup/core/navigation/route_names.dart';


import 'package:skillup/features/profile/screens/profile_screen.dart';

class ProfileRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: RoutePaths.profile,
      name: RouteNames.profile,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const ProfileScreen()),
    ),
  ];
}