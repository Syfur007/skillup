// explore_routes.dart
// Centralized route definitions for explore feature.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillup/core/navigation/route_names.dart';

import 'package:skillup/features/explore/screens/roadmap_list_screen.dart';
import 'package:skillup/features/explore/screens/roadmap_detail_screen.dart';
import 'package:skillup/features/explore/screens/create_roadmap_screen.dart';
import 'package:skillup/domain/entities/roadmap.dart';

/// Explore feature routes
class ExploreRoutes {
  static List<RouteBase> get routes => [
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
  ];
}