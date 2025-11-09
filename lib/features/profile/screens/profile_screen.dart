// profile_screen.dart
// User profile screen for viewing and editing user profile information.

import 'package:flutter/material.dart';
import '../../explore/models/roadmap.dart';
import '../../explore/services/mock_roadmap_service.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/user_roadmap.dart';
import '../services/firestore_user_service.dart';
import 'package:skillup/features/profile/screens/profile_setup_screen.dart';
import 'package:skillup/core/navigation/navigation_extensions.dart';
import 'package:skillup/core/navigation/route_names.dart';
import 'package:skillup/features/auth/providers/auth_provider.dart' as app_auth;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'dart:async';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final _userService = FirestoreUserService();
  final _roadmapService = MockRoadmapService();

  User? _user;
  List<UserRoadmap> _userRoadmaps = [];
  List<Roadmap> _allRoadmaps = [];
  bool _loading = true;
  bool _isSigningOut = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        _allRoadmaps = all;
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

  int get _activeCount => _userRoadmaps.length;
  int get _completedCount =>
      _userRoadmaps.where((r) => r.progress >= 1.0).length;

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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.9),
            Theme.of(context).primaryColor.withValues(alpha: 0.12),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          _avatar(_user?.avatarKey ?? 'default', 100),
          const SizedBox(height: 12),
          Text(
            _user?.displayName ?? _user?.username ?? 'New user',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text('Active', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Text(
                    '$_activeCount',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Column(
                children: [
                  Text(
                    'Completed',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$_completedCount',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Information Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, size: 20, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Account Information',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const Divider(),
                  _buildInfoRow('Username', _user?.username ?? 'N/A'),
                  if (_user?.displayName != null)
                    _buildInfoRow('Display Name', _user!.displayName!),
                  if (_user?.privacySettings.emailVisible ?? false)
                    _buildInfoRow('Email', _user?.email ?? 'N/A', icon: Icons.email),
                  _buildInfoRow(
                    'Member Since',
                    _formatDate(_user?.createdAt),
                    icon: Icons.calendar_today,
                  ),
                  _buildInfoRow(
                    'Total Points',
                    '${_user?.totalPoints ?? 0}',
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
                      _buildPrivacyChip(
                        'Email',
                        _user?.privacySettings.emailVisible ?? false,
                      ),
                      _buildPrivacyChip(
                        'Interests',
                        _user?.privacySettings.interestsVisible ?? true,
                      ),
                      _buildPrivacyChip(
                        'Bio',
                        _user?.privacySettings.bioVisible ?? true,
                      ),
                      _buildPrivacyChip(
                        'Progress',
                        _user?.privacySettings.progressVisible ?? true,
                      ),
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

  Widget _buildInfoRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
          ],
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyChip(String label, bool isVisible) {
    return Chip(
      label: Text(label),
      avatar: Icon(
        isVisible ? Icons.visibility : Icons.visibility_off,
        size: 16,
      ),
      backgroundColor: isVisible
          ? Colors.green.withAlpha(25)
          : Colors.grey.withAlpha(25),
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
                  final progress = (ur.progress).clamp(0.0, 1.0);
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
                          Text('${r.stages.length} stages'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _removeRoadmapFromProfile(r.id),
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

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, inner) => [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            actions: [
              IconButton(
                tooltip: 'Logout',
                onPressed: _isSigningOut ? null : _handleSignOut,
                icon: _isSigningOut
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(background: _buildHeader()),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'PROFILE'),
                  Tab(text: 'ROADMAPS'),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [_buildProfileTab(), _buildRoadmapsTab()],
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverTabBarDelegate oldDelegate) => false;
}
