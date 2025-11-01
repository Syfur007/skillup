// navigation_extensions.dart
// Extension methods for simplified navigation throughout the app.
// Provides type-safe navigation helpers that work with GoRouter.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Extension on BuildContext for easier navigation
extension NavigationExtensions on BuildContext {
  /// Navigate to a named route (replaces current route in stack)
  void goToNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    GoRouter.of(this).goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Push a named route onto the navigation stack
  void pushNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    GoRouter.of(this).pushNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Navigate to a path (replaces current route)
  void goToPath(String path, {Object? extra}) {
    GoRouter.of(this).go(path, extra: extra);
  }

  /// Push a path onto the navigation stack
  void pushPath(String path, {Object? extra}) {
    GoRouter.of(this).push(path, extra: extra);
  }

  /// Pop the current route off the navigation stack
  void popRoute() {
    if (GoRouter.of(this).canPop()) {
      GoRouter.of(this).pop();
    }
  }

  /// Check if the current route can be popped
  bool canPop() => GoRouter.of(this).canPop();
}