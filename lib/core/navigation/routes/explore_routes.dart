// explore_routes.dart
// Centralized route definitions for explore feature.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillup/core/navigation/route_names.dart';

import 'package:skillup/features/explore/screens/explore_screen.dart';
import 'package:skillup/features/explore/screens/roadmap_detail_screen.dart';
import 'package:skillup/features/explore/screens/create_roadmap_screen.dart';
import 'package:skillup/features/explore/screens/module_detail_screen.dart';
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
    GoRoute(
      path: RoutePaths.moduleDetail,
      name: RouteNames.moduleDetail,
      pageBuilder: (context, state) {
        // Extract module id from path params or fallback to extra (which may be a String)
        String? id;
        final pathId = state.pathParameters['id'];
        if (pathId != null && pathId.isNotEmpty) {
          id = pathId;
        } else if (state.extra is String) {
          id = state.extra as String;
        }

        if (id == null) {
          return MaterialPage(
            key: state.pageKey,
            child: Scaffold(
              appBar: AppBar(title: const Text('Module')),
              body: const Center(child: Text('Module not found')),
            ),
          );
        }

        return MaterialPage(
          key: state.pageKey,
          child: ModuleScreen(moduleId: id),
        );
      },
    ),
  ];
}