// main.dart
// App entry point, environment setup, and service initialization.

import 'dart:async';
import 'package:flutter/material.dart';
import 'app.dart';

/// Entrypoint for the SkillUp application.
///
/// Initializes bindings and any platform services (Firebase, Sentry, etc.)
/// before running the app. For now, service initialization is a placeholder
/// so the app can start quickly during frontend-first development.
Future<void> main() async {
  // Set up a top-level Flutter error handler so we can capture unexpected
  // exceptions during development. Replace with production reporting
  // (Sentry, Firebase Crashlytics) later.
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // TODO: report to error tracking service.
  };

  // Use runZonedGuarded to catch errors from async code that wouldn't
  // be caught by FlutterError.onError.
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // TODO: Initialize services here (e.g., await Firebase.initializeApp()).

    runApp(const App());
  }, (error, stack) {
    // Handle uncaught errors.
    // TODO: report to error tracking service.
    // ignore: avoid_print
    print('Uncaught error: $error');
  });
}
