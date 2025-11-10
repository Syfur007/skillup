// profile_screen.dart
// User profile screen for viewing and editing user profile information.

import 'package:flutter/material.dart';
import 'package:skillup/domain/entities/roadmap.dart';
import 'package:skillup/core/utils/progress_calculator.dart';
import '../../explore/services/firestore_roadmap_service.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/user_roadmap.dart';
import '../services/firestore_user_service.dart';
import 'package:skillup/features/profile/screens/profile_setup_screen.dart';
import 'package:skillup/core/navigation/navigation_extensions.dart';
import 'package:skillup/core/navigation/route_names.dart';
import 'package:skillup/features/auth/providers/auth_provider.dart' as app_auth;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'dart:async';

// Widgets
import '../widgets/profile_header.dart';
import '../widgets/profile_info_row.dart';
import '../widgets/privacy_chip.dart';
import 'enrolled_roadmap_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userService = FirestoreUserService();
  final _roadmapService = FirestoreRoadmapService();

  User? _user;
  List<UserRoadmap> _userRoadmaps = [];
  List<Roadmap> _allRoadmaps = [];
  bool _loading = true;
  bool _isSigningOut = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final user = await _userService.getCurrentUser();
      final all = await _roadmapService.getRoadmaps();
      final assigned = await _userService.getUserRoadmaps();
      if (!mounted) return;
      setState(() {
        _user = user;
        _allRoadmaps = all.cast<Roadmap>();
        _userRoadmaps = assigned;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _handleSignOut() async {
    if (_isSigningOut) return;
    setState(() => _isSigningOut = true);
    Exception? error;
    try {
      // Add a timeout to avoid hanging indefinitely if signOut doesn't complete.
      await app_auth.AuthProvider().signOut().timeout(
        const Duration(seconds: 10),
      );

      // Wait a short period for Firebase to update the currentUser to null.
      final end = DateTime.now().add(const Duration(seconds: 3));
      while (fb.FirebaseAuth.instance.currentUser != null &&
          DateTime.now().isBefore(end)) {
        await Future.delayed(const Duration(milliseconds: 150));
      }
    } on TimeoutException catch (_) {
      error = Exception('Sign out timed out.');
    } catch (e) {
      error = e is Exception ? e : Exception('Sign out failed');
    } finally {
      // Ensure loading flag is cleared if still mounted.
      if (mounted) setState(() => _isSigningOut = false);

      // Show error if any
      if (error != null && mounted) {
        final message = error.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }

      // Navigate to login regardless to ensure UI doesn't remain stuck on a page
      // that expects a signed-in user. The router will also react to auth state.
      if (mounted) context.goToNamed(RouteNames.login);
    }
  }

  int get _activeCount => _userRoadmaps.length;
  int get _completedCount =>
      _userRoadmaps.where((ur) {
        final rm = _findRoadmap(ur.roadmapId);
        final pct = ProgressCalculator.getProgressFromUserRoadmap(
          userRoadmap: ur,
          roadmap: rm,
        );
        return pct >= 1.0;
      }).length;


  // Helper: find roadmap by id in _allRoadmaps
  Roadmap? _findRoadmap(String id) {
    try {
      return _allRoadmaps.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _addRoadmapToProfile(String roadmapId) async {
    try {
      await _userService.addRoadmap(roadmapId);
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Roadmap added to your profile')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add roadmap'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removeRoadmapFromProfile(String roadmapId) async {
    try {
      await _userService.removeRoadmap(roadmapId);
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Roadmap removed from your profile')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to remove roadmap'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header widget
          ProfileHeader(
            user: _user,
            activeCount: _activeCount,
            completedCount: _completedCount,
          ),
          const SizedBox(height: 16),

          // Account Information Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Account Information',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const Divider(),
                  ProfileInfoRow(label: 'Username', value: _user?.username ?? 'N/A', icon: Icons.person,),
                  if (_user?.displayName != null)
                    ProfileInfoRow(label: 'Display Name', value: _user!.displayName!),
                  if (_user?.privacySettings.emailVisible ?? false)
                    ProfileInfoRow(label: 'Email', value: _user?.email ?? 'N/A', icon: Icons.email),
                  ProfileInfoRow(
                    label: 'Member Since',
                    value: _formatDate(_user?.createdAt),
                    icon: Icons.calendar_today,
                  ),
                  ProfileInfoRow(
                    label: 'Total Points',
                    value: '${_user?.totalPoints ?? 0}',
                    icon: Icons.stars,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Bio Section
          if (_user?.bio != null && (_user?.privacySettings.bioVisible ?? true)) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 20, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'About',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_user!.bio!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Interests Section
          if (_user != null && _user!.interests.isNotEmpty && (_user?.privacySettings.interestsVisible ?? true)) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.interests, size: 20, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Interests',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _user!.interests
                          .map((i) => Chip(
                                label: Text(i),
                                avatar: Icon(Icons.label, size: 16),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Privacy Settings Info
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.privacy_tip, size: 20, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Privacy Settings',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your privacy settings in Edit Profile',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      PrivacyChip('Email', _user?.privacySettings.emailVisible ?? false),
                      PrivacyChip('Interests', _user?.privacySettings.interestsVisible ?? true),
                      PrivacyChip('Bio', _user?.privacySettings.bioVisible ?? true),
                      PrivacyChip('Progress', _user?.privacySettings.progressVisible ?? true),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          FilledButton.icon(
            onPressed: () async {
              final route = MaterialPageRoute(
                builder: (_) => const ProfileSetupScreen(),
              );
              await Navigator.of(context).push(route);
              await _load();
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapsTab() {
    // Map assigned userRoadmaps to Roadmap objects (preserve ordering)
    final assigned = _userRoadmaps
        .map((ur) => _findRoadmap(ur.roadmapId))
        .where((r) => r != null)
        .cast<Roadmap>()
        .toList();
    final assignedIds = _userRoadmaps.map((e) => e.roadmapId).toSet();
    final available = _allRoadmaps
        .where((r) => !assignedIds.contains(r.id))
        .toList();

    return RefreshIndicator(
      onRefresh: _load,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Roadmaps',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (assigned.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    const Text(
                      'You have not started any roadmaps yet.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: () => context.pushPath('/explore'),
                      child: const Text('Explore roadmaps'),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: assigned.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, idx) {
                  final r = assigned[idx];
                  final ur = _userRoadmaps.firstWhere(
                    (u) => u.roadmapId == r.id,
                  );
                  final progress = ProgressCalculator.getProgressFromUserRoadmap(
                    userRoadmap: ur,
                    roadmap: r,
                  );
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${(progress * 100).round()}%'),
                      ),
                      title: Text(r.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          LinearProgressIndicator(value: progress),
                          const SizedBox(height: 6),
                          // Use roadmap.totalStages when available; otherwise derive from sample modules
                          Text('${_deriveTotalStages(r)} stages'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _removeRoadmapFromProfile(r.id),
                      ),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EnrolledRoadmapScreen(
                              roadmap: r,
                              userRoadmap: ur,
                            ),
                          ),
                        );
                        // Reload user roadmaps to pick up any persisted progress
                        await _load();
                      },
                    ),
                  );
                },
              ),
            const SizedBox(height: 24),
            const Text(
              'Available Roadmaps',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (available.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('No additional roadmaps available'),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: available.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, idx) {
                  final r = available[idx];
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.explore)),
                      title: Text(r.title),
                      subtitle: Text(
                        r.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => _addRoadmapToProfile(r.id),
                        child: const Text('Add'),
                      ),
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/roadmap-detail',
                        arguments: r,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Use a simple AppBar with TabBar for navigation. DefaultTabController
    // makes TabController management easier and keeps the topbar simple.
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_user?.displayName ?? 'Profile'),
          actions: [
            IconButton(
              tooltip: 'Logout',
              onPressed: _isSigningOut ? null : _handleSignOut,
              icon: _isSigningOut
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.logout),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'PROFILE'),
              Tab(text: 'ROADMAPS'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildProfileTab(), _buildRoadmapsTab()],
        ),
      ),
    );
  }


  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // Derive a roadmap's total stages from roadmap metadata
  int _deriveTotalStages(Roadmap r) {
    return r.totalStages;
  }
}
