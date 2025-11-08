// profile_screen.dart
// User profile screen for viewing and editing user profile information.

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/mock_user_service.dart';
import 'package:skillup/screens/onboarding/profile_setup_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _service = MockUserService();
  User? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = await _service.getCurrentUser();
    if (!mounted) return;
    setState(() {
      _user = user;
      _loading = false;
    });
  }

  Widget _avatar(String key, double size) {
    // map avatarKey to a built-in icon/avatar
    switch (key) {
      case 'group':
        return CircleAvatar(
          radius: size / 2,
          backgroundColor: Colors.blue.shade50,
          child: Icon(Icons.group, size: size * 0.5, color: Colors.blue),
        );
      case 'trophy':
        return CircleAvatar(
          radius: size / 2,
          backgroundColor: Colors.amber.shade50,
          child: Icon(
            Icons.emoji_events,
            size: size * 0.5,
            color: Colors.amber.shade700,
          ),
        );
      default:
        return CircleAvatar(
          radius: size / 2,
          backgroundColor: Colors.grey.shade300,
          child: FlutterLogo(size: size * 0.6),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No profile found', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  // navigate to profile setup
                  final route = MaterialPageRoute(
                    builder: (_) => const ProfileSetupScreen(),
                  );
                  await Navigator.of(context).push(route);
                  await _load();
                },
                child: const Text('Set up profile'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _avatar(_user!.avatarKey, 96),
            const SizedBox(height: 12),
            Text(
              _user!.username,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            if (_user!.bio != null && _user!.bio!.isNotEmpty) Text(_user!.bio!),
            const SizedBox(height: 12),
            if (_user!.interests != null && _user!.interests!.isNotEmpty)
              Wrap(
                spacing: 8,
                children: _user!.interests!
                    .map((i) => Chip(label: Text(i)))
                    .toList(),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final route = MaterialPageRoute(
                  builder: (_) => const ProfileSetupScreen(),
                );
                await Navigator.of(context).push(route);
                await _load();
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
