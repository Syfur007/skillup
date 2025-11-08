// dashboard_screen.dart
// Dashboard screen that aggregates key metrics and quick actions for users.

import 'package:flutter/material.dart';
import 'package:skillup/core/navigation/navigation_extensions.dart';
import 'package:skillup/core/navigation/route_names.dart';
import '../../explore/models/roadmap.dart';
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
                backgroundColor: color.withOpacity(0.15),
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
      child: ListTile(
        leading: CircleAvatar(child: Icon(Icons.book)),
        title: Text(r.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(r.description, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            LinearProgressIndicator(value: progress),
          ],
        ),
        onTap: () {
          // navigate to roadmap list/detail depending on routing setup
          context.pushNamed(
            RouteNames.roadmapDetail,
            pathParameters: {'id': r.id},
            extra: r,
          );
        },
      ),
    );
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

              // Recent / Active roadmaps
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your roadmaps',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),

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
                          const Text('Failed to load roadmaps'),
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
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: Text('No roadmaps available')),
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
                child: const Text('See all roadmaps'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
