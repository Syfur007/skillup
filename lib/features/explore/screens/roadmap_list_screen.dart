// roadmap_list_screen.dart
// Screen that displays a list of available roadmaps. Uses RoadmapProvider to
// obtain data and show loading/error states.

import 'package:flutter/material.dart';
import 'package:skillup/core/navigation/navigation.dart';
import 'package:skillup/core/navigation/route_names.dart';
import '../models/roadmap.dart';
import 'package:skillup/features/explore/screens/create_roadmap_screen.dart';
import '../services/firestore_roadmap_service.dart';
import '../widgets/roadmap_card.dart';

class RoadmapListScreen extends StatefulWidget {
  const RoadmapListScreen({Key? key}) : super(key: key);

  @override
  State<RoadmapListScreen> createState() => _RoadmapListScreenState();
}

class _RoadmapListScreenState extends State<RoadmapListScreen> {
  final _service = FirestoreRoadmapService();
  List<Roadmap>? _roadmaps;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRoadmaps();
  }

  Future<void> _loadRoadmaps() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final roadmaps = await _service.getRoadmaps();
      if (!mounted) return;
      setState(() {
        _roadmaps = roadmaps;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load roadmaps';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Roadmaps')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // open create roadmap screen using Navigator so we can await until it returns
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateRoadmapScreen()),
          );
          await _loadRoadmaps();
        },
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
            ElevatedButton(
              onPressed: _loadRoadmaps,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_roadmaps?.isEmpty ?? true) {
      return const Center(child: Text('No roadmaps available'));
    }

    return RefreshIndicator(
      onRefresh: _loadRoadmaps,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: _roadmaps!.length,
        itemBuilder: (context, index) {
          final roadmap = _roadmaps![index];
          return RoadmapCard(
            roadmap: roadmap,
            onTap: () {
              // Use GoRouter helper to push the roadmap detail path and pass the roadmap object as extra
              context.pushPath(
                RoutePaths.roadmapDetailPath(roadmap.id),
                extra: roadmap,
              );
            },
          );
        },
      ),
    );
  }
}
