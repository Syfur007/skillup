// filepath: /home/syfur/Android/Flutter/skillup/lib/features/profile/screens/profile_setup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skillup/core/navigation/navigation_extensions.dart';
import 'package:skillup/core/navigation/route_names.dart';
import '../../../domain/entities/user.dart';
import '../services/firestore_user_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _displayNameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _interestsCtrl = TextEditingController();
  final _service = FirestoreUserService();

  String _avatarKey = 'default';
  String? _usernameError;
  bool _saving = false;
  bool _loading = true;
  User? _currentUser;

  // Privacy settings
  bool _emailVisible = false;
  bool _interestsVisible = true;
  bool _bioVisible = true;
  bool _progressVisible = true;

  final Map<String, String> _avatarOptions = {
    'default': 'Default',
    'group': 'Community',
    'trophy': 'Achievements',
  };

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    setState(() => _loading = true);
    try {
      final user = await _service.getCurrentUser();
      if (user != null && mounted) {
        setState(() {
          _currentUser = user;
          _usernameCtrl.text = user.username;
          _displayNameCtrl.text = user.displayName ?? '';
          _bioCtrl.text = user.bio ?? '';
          _interestsCtrl.text = user.interests.join(', ');
          _avatarKey = user.avatarKey;
          _emailVisible = user.privacySettings.emailVisible;
          _interestsVisible = user.privacySettings.interestsVisible;
          _bioVisible = user.privacySettings.bioVisible;
          _progressVisible = user.privacySettings.progressVisible;
        });
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _displayNameCtrl.dispose();
    _bioCtrl.dispose();
    _interestsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _usernameError = null;
      _saving = true;
    });

    try {
      // Ensure the user is signed in before attempting to save to Firestore.
      final current = fb.FirebaseAuth.instance.currentUser;
      if (current == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be signed in to save your profile.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final username = _usernameCtrl.text.trim();

      // Only check username uniqueness if it changed
      if (_currentUser == null || _currentUser!.username != username) {
        final isUnique = await _service.isUsernameUnique(username);
        if (!isUnique) {
          setState(() => _usernameError = 'Username already taken');
          return;
        }
      }

      final displayName = _displayNameCtrl.text.trim();
      final bio = _bioCtrl.text.trim();
      final interests = _interestsCtrl.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final privacySettings = UserPrivacySettings(
        emailVisible: _emailVisible,
        interestsVisible: _interestsVisible,
        bioVisible: _bioVisible,
        progressVisible: _progressVisible,
      );

      final user = _currentUser != null
          ? _currentUser!.copyWith(
              username: username,
              displayName: displayName.isEmpty ? null : displayName,
              bio: bio.isEmpty ? null : bio,
              interests: interests,
              avatarKey: _avatarKey,
              privacySettings: privacySettings,
              onboardingCompleted: true,
            )
          : User(
              id: current.uid,
              email: current.email ?? '',
              username: username,
              displayName: displayName.isEmpty ? null : displayName,
              bio: bio.isEmpty ? null : bio,
              interests: interests,
              avatarKey: _avatarKey,
              privacySettings: privacySettings,
              onboardingCompleted: true,
            );

      await _service.saveUser(user, isNewUser: _currentUser == null);

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      // Navigate using GoRouter
      context.goToNamed(RouteNames.profile);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  String? _usernameValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Username required';
    final v = value.trim();
    if (v.length < 3 || v.length > 30) {
      return 'Username must be 3-30 characters';
    }
    final alnum = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!alnum.hasMatch(v)) return 'Use only letters, numbers and underscores';
    return null;
  }

  Widget _buildAvatarPreview() {
    switch (_avatarKey) {
      case 'group':
        return CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blue.shade50,
          child: Icon(Icons.group, size: 40, color: Colors.blue),
        );
      case 'trophy':
        return CircleAvatar(
          radius: 40,
          backgroundColor: Colors.amber.shade50,
          child: Icon(
            Icons.emoji_events,
            size: 40,
            color: Colors.amber.shade700,
          ),
        );
      default:
        return CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey.shade300,
          child: const FlutterLogo(size: 36),
        );
    }
  }

  Widget _buildPrivacySection() {
    return ExpansionTile(
      title: const Text('Privacy Settings'),
      subtitle: const Text('Control who can see your information'),
      leading: const Icon(Icons.privacy_tip),
      children: [
        SwitchListTile(
          title: const Text('Email visible'),
          subtitle: const Text('Allow others to see your email address'),
          value: _emailVisible,
          onChanged: (val) => setState(() => _emailVisible = val),
        ),
        SwitchListTile(
          title: const Text('Interests visible'),
          subtitle: const Text('Show your interests on your profile'),
          value: _interestsVisible,
          onChanged: (val) => setState(() => _interestsVisible = val),
        ),
        SwitchListTile(
          title: const Text('Bio visible'),
          subtitle: const Text('Display your bio publicly'),
          value: _bioVisible,
          onChanged: (val) => setState(() => _bioVisible = val),
        ),
        SwitchListTile(
          title: const Text('Progress visible'),
          subtitle: const Text('Show your learning progress to others'),
          value: _progressVisible,
          onChanged: (val) => setState(() => _progressVisible = val),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentUser == null ? 'Set up your profile' : 'Edit Profile'),
        actions: [
          if (_currentUser == null)
            TextButton(
              onPressed: _skip,
              child: const Text('Skip', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildAvatarPreview(),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _avatarOptions.entries.map((e) {
                  final selected = e.key == _avatarKey;
                  return ChoiceChip(
                    label: Text(e.value),
                    selected: selected,
                    onSelected: (_) => setState(() => _avatarKey = e.key),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _usernameCtrl,
                decoration: InputDecoration(
                  labelText: 'Username *',
                  hintText: _currentUser?.username ?? 'Enter username',
                  errorText: _usernameError,
                  border: const OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
                ],
                validator: _usernameValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _displayNameCtrl,
                decoration: InputDecoration(
                  labelText: 'Display Name (optional)',
                  hintText: _currentUser?.displayName ?? 'Your display name',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioCtrl,
                decoration: InputDecoration(
                  labelText: 'Bio (optional)',
                  hintText: _currentUser?.bio ?? 'Tell us about yourself',
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
                maxLength: 500,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _interestsCtrl,
                decoration: InputDecoration(
                  labelText: 'Interests / Goals (optional)',
                  hintText: _currentUser != null && _currentUser!.interests.isNotEmpty
                      ? _currentUser!.interests.join(', ')
                      : 'Flutter, AI, Web Development',
                  helperText: 'Separate with commas',
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              _buildPrivacySection(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(_saving ? 'Saving...' : 'Save Profile'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

