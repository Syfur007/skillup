// explore_screen.dart
// Main explore screen displaying roadmaps and modules for discovery

import 'package:flutter/material.dart';
import 'package:skillup/core/navigation/navigation.dart';
import 'package:skillup/domain/entities/roadmap.dart';
import 'package:skillup/domain/entities/module.dart';
import '../services/firestore_roadmap_service.dart';
import '../services/firestore_module_service.dart';
import '../widgets/roadmap_card.dart';
import '../widgets/module_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Use Firestore services
  final _roadmapService = FirestoreRoadmapService();
  final _moduleService = FirestoreModuleService();

  List<Roadmap>? _roadmaps;
  List<Module>? _modules;
  bool _loading = true;
  String? _error;
  bool _showAllRoadmaps = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final roadmaps = await _roadmapService.getRoadmaps();
      final modules = await _moduleService.getModules(limit: 12);

      if (!mounted) return;
      setState(() {
        _roadmaps = roadmaps;
        _modules = modules;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load content';
        _loading = false;
      });
    }
  }

  void _navigateToSearch() {
    // TODO: Implement search functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Search feature coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _navigateToSearch,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRoadmapsSection(),
            const SizedBox(height: 32),
            _buildModulesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoadmapsSection() {
    if (_roadmaps?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    final displayCount = _showAllRoadmaps ? _roadmaps!.length : (_roadmaps!.length > 5 ? 5 : _roadmaps!.length);
    final roadmapsToShow = _roadmaps!.take(displayCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Learning Roadmaps',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (_roadmaps!.length > 5)
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAllRoadmaps = !_showAllRoadmaps;
                  });
                },
                child: Text(_showAllRoadmaps ? 'Show Less' : 'Show More'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: roadmapsToShow.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final roadmap = roadmapsToShow[index];
            return RoadmapCard(
              roadmap: roadmap,
              onTap: () {
                context.pushPath(
                  RoutePaths.roadmapDetailPath(roadmap.id),
                  extra: roadmap,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildModulesSection() {
    if (_modules?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Modules',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: _modules!.length,
          itemBuilder: (context, index) {
            final module = _modules![index];
            return ModuleCard(
              module: module,
              onTap: () {
                context.pushPath(
                  RoutePaths.moduleDetailPath(module.id),
                  extra: module,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

// Keep the old RoadmapListScreen for backward compatibility
class RoadmapListScreen extends StatelessWidget {
  const RoadmapListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExploreScreen();
  }
}
