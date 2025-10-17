// app.dart
// Main MaterialApp widget, theme, and router setup.
// This file will compose the top-level App widget and apply ThemeData and routing.

import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

/// Top-level App widget.
/// Keeps the composition of Theme and Router in one place so presentation
/// code (features) can remain focused on UI/state only.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillUp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // For the skeleton, use a simple placeholder home screen.
      home: const _PlaceholderHome(),
    );
  }
}

/// A small placeholder home screen used while wiring the app.
/// Replace this with real feature routing (GoRouter or Navigator 2.0) later.
class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SkillUp'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.school,
              size: 72,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to SkillUp',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'This is a placeholder home screen. Build features under lib/features/',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // For now show a simple dialog — replace with real navigation later.
                showDialog<void>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Placeholder'),
                    content: const Text('Feature routing will be added here.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Learn more'),
            ),
          ],
        ),
      ),
    );
  }
}
