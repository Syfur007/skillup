import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../features/profile/models/user.dart';
import '../../features/profile/services/mock_user_service.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _interestsCtrl = TextEditingController();
  final _service = MockUserService();

  String _avatarKey = 'default';
  String? _usernameError;
  bool _saving = false;

  final Map<String, String> _avatarOptions = {
    'default': 'Default',
    'group': 'Community',
    'trophy': 'Achievements',
  };

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _bioCtrl.dispose();
    _interestsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _usernameError = null;
    });

    if (!_formKey.currentState!.validate()) return;

    final username = _usernameCtrl.text.trim();
    setState(() => _saving = true);
    final isUnique = await _service.isUsernameUnique(username);
    if (!isUnique) {
      setState(() {
        _usernameError = 'Username already taken';
        _saving = false;
      });
      return;
    }

    final bio = _bioCtrl.text.trim();
    final interests = _interestsCtrl.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final user = User(
      username: username,
      bio: bio.isEmpty ? null : bio,
      interests: interests.isEmpty ? null : interests,
      avatarKey: _avatarKey,
    );

    await _service.saveUser(user);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  String? _usernameValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Username required';
    final v = value.trim();
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
          child: FlutterLogo(size: 36),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set up your profile'),
        actions: [
          TextButton(
            onPressed: _skip,
            child: const Text('Skip', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameCtrl,
                decoration: InputDecoration(
                  labelText: 'Username',
                  errorText: _usernameError,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
                ],
                validator: _usernameValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bioCtrl,
                decoration: const InputDecoration(labelText: 'Bio (optional)'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _interestsCtrl,
                decoration: const InputDecoration(
                  labelText: 'Interests / Goals (comma separated, optional)',
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
