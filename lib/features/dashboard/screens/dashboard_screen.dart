// dashboard_screen.dart
// Dashboard screen that aggregates key metrics and quick actions for users.

import 'package:flutter/material.dart';
import 'package:skillup/core/navigation/navigation_extensions.dart';
import 'package:skillup/core/navigation/route_names.dart';
import '../../explore/models/roadmap.dart';
import '../../explore/models/sample_roadmap_data.dart';
import '../../explore/services/mock_roadmap_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _service = MockRoadmapService();
  late Future<List<Roadmap>> _roadmapsFuture;

  @override
  void initState() {
    super.initState();
    _roadmapsFuture = _service.getRoadmaps();
  }

  Future<void> _refresh() async {
    setState(() {
      _roadmapsFuture = _service.getRoadmaps();
    });
    await _roadmapsFuture;
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 6),
                    Text(value, style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roadmapTile(Roadmap r) {
    // Simple progress placeholder (random-ish based on id hash)
    final progress = (r.id.hashCode % 100) / 100;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            RouteNames.roadmapDetail,
            pathParameters: {'id': r.id},
            extra: r,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: Title, Difficulty Badge, and Icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                    child: Icon(
                      Icons.school,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title and Difficulty
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor(r.difficulty).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                r.difficulty.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _getDifficultyColor(r.difficulty),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (r.averageRating > 0)
                              Row(
                                children: [
                                  Icon(Icons.star, size: 14, color: Colors.amber),
                                  const SizedBox(width: 2),
                                  Text(
                                    r.averageRating.toStringAsFixed(1),
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                r.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 10),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Metrics row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetricChip('${r.totalModules} Modules', Icons.layers),
                  _buildMetricChip('${r.totalTasks} Tasks', Icons.checklist),
                  _buildMetricChip('${r.estimatedHours}h', Icons.schedule),
                  if (r.enrolledCount > 0)
                    _buildMetricChip('${r.enrolledCount} Enrolled', Icons.people),
                ],
              ),

              // Tags
              if (r.tags.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: r.tags.take(3).map((tag) {
                    return Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(fontSize: 11),
                      ),
                      backgroundColor: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricChip(String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Theme.of(context).primaryColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      case 'expert':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Summary row
              Row(
                children: [
                  _buildSummaryCard(
                    'Active',
                    '3',
                    Colors.blue,
                    Icons.play_circle_fill,
                  ),
                  const SizedBox(width: 12),
                  _buildSummaryCard(
                    'Completed',
                    '7',
                    Colors.green,
                    Icons.emoji_events,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Quick actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          context.pushNamed(RouteNames.roadmapList),
                      icon: const Icon(Icons.explore),
                      label: const Text('Explore Roadmaps'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Featured Roadmaps Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Featured Roadmaps',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 12),

              FutureBuilder<List<Roadmap>>(
                future: Future.value(SampleRoadmapData.getSampleRoadmapList()),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snap.hasError) {
                    return Center(
                      child: Text('Error loading featured roadmaps: ${snap.error}'),
                    );
                  }

                  final roadmaps = snap.data ?? [];
                  if (roadmaps.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: Text('No featured roadmaps available')),
                    );
                  }

                  // Show top 3 featured roadmaps
                  final featured = roadmaps.take(3).toList();
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: featured.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => _roadmapTile(featured[index]),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Your roadmaps
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your roadmaps',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 12),

              FutureBuilder<List<Roadmap>>(
                future: _roadmapsFuture,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snap.hasError) {
                    return Center(
                      child: Column(
                        children: [
                          const Text('Failed to load your roadmaps'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _refresh,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  final roadmaps = snap.data ?? [];
                  if (roadmaps.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          const Text('You haven\'t started any roadmaps yet'),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: () => context.pushNamed(RouteNames.roadmapList),
                            icon: const Icon(Icons.explore),
                            label: const Text('Explore Roadmaps'),
                          ),
                        ],
                      ),
                    );
                  }

                  // show top 5 as a list
                  final show = roadmaps.take(5).toList();
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: show.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => _roadmapTile(show[index]),
                  );
                },
              ),

              const SizedBox(height: 24),
              // Footer action
              TextButton(
                onPressed: () => context.pushNamed(RouteNames.roadmapList),
                child: const Text('See all roadmaps →'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
