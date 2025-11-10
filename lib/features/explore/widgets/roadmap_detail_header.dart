import 'package:flutter/material.dart';
import 'package:skillup/domain/entities/roadmap.dart';

class RoadmapDetailHeader extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final RoadmapDifficulty difficulty;
  final int estimatedHours;
  final double averageRating;
  final int enrolledCount;
  final List<String> tags;
  final double? progress; // optional progress 0.0..1.0 to show slim progress bar

  const RoadmapDetailHeader({
    super.key,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.difficulty,
    required this.estimatedHours,
    required this.averageRating,
    required this.enrolledCount,
    this.tags = const [],
    this.progress,
  });

  Color _getDifficultyColor(RoadmapDifficulty difficulty) {
    switch (difficulty) {
      case RoadmapDifficulty.beginner:
        return Colors.green;
      case RoadmapDifficulty.intermediate:
        return Colors.orange;
      case RoadmapDifficulty.advanced:
        return Colors.red;
      case RoadmapDifficulty.expert:
        return Colors.deepPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final diffLabel = difficulty.name.toUpperCase();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
            Theme.of(context).primaryColor.withValues(alpha: 0.2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Difficulty Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(difficulty),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  diffLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                icon: Icons.schedule,
                label: '${estimatedHours}h',
                context: context,
              ),
              _buildStatItem(
                icon: Icons.star,
                label: averageRating.toStringAsFixed(1),
                context: context,
              ),
              _buildStatItem(
                icon: Icons.people,
                label: '$enrolledCount',
                context: context,
              ),
            ],
          ),

          // Progress bar (optional) - display above tags when provided with numeric label
          if (progress != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress!.clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(progress! * 100).round()}%',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],

          // Tags
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: tags.take(3).map((tag) {
                return Chip(
                  label: Text(
                    tag,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  labelStyle: const TextStyle(color: Colors.white),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white70),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
