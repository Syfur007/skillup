import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillup/core/navigation/route_names.dart';

/// Simple splash screen that displays the app logo and routes to the
/// appropriate next screen after performing quick checks (onboarding flag,
/// auth state). This runs a short delay to ensure the splash is visible.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _delay = const Duration(milliseconds: 800);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_delay, _checkAndNavigate);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkAndNavigate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;
      final user = FirebaseAuth.instance.currentUser;

      if (!onboardingCompleted) {
        if (mounted) context.go(RoutePaths.onboarding);
        return;
      }

      if (user == null) {
        if (mounted) context.go(RoutePaths.login);
        return;
      }

      if (mounted) context.go(RoutePaths.home);
    } catch (e) {
      // On error, send user to onboarding as a safe fallback
      if (mounted) context.go(RoutePaths.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              FlutterLogo(size: 96),
              SizedBox(height: 24),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

