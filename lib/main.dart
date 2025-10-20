// main.dart
// App entry point, environment setup, and service initialization.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';
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
  };

  // Use runZonedGuarded to catch errors from async code that wouldn't
  // be caught by FlutterError.onError.
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    FlutterError.onError =  (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      FirebaseCrashlytics.instance.recordFlutterError(details);
    };
    
    runApp(
      const ProviderScope(
        child: App(),
      ),
    );
  }, (error, stack) {
    // Handle uncaught errors.
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}
