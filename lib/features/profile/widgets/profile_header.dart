// profile_header.dart
import 'package:flutter/material.dart';
import '../../../domain/models/user.dart';

class ProfileHeader extends StatelessWidget {
  final User? user;
  final int activeCount;
  final int completedCount;
  final double avatarSize;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.activeCount,
    required this.completedCount,
    this.avatarSize = 80.0,
  });

  Widget _avatar(String key, double size) {
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

  Widget _statColumn(BuildContext context, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 6),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.9),
            Theme.of(context).primaryColor.withValues(alpha: 0.12),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _avatar(user?.avatarKey ?? 'default', avatarSize),
          const SizedBox(height: 8),
          Text(
            user?.displayName ?? user?.username ?? 'New user',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _statColumn(context, 'Active', '$activeCount'),
              const SizedBox(width: 20),
              _statColumn(context, 'Completed', '$completedCount'),
            ],
          ),
        ],
      ),
    );
  }
}

