// roadmap_detail_screen.dart
// Screen that shows detailed information about a single roadmap. Should accept
// a Roadmap entity and render its content.

// Placeholder: implement RoadmapDetailScreen widget here.

import 'package:flutter/material.dart';
import '../models/roadmap.dart';
import '../widgets/roadmap_stage_widget.dart';
import '../../profile/services/firestore_user_service.dart';

class RoadmapDetailScreen extends StatefulWidget {
  final Roadmap roadmap;

  const RoadmapDetailScreen({Key? key, required this.roadmap})
    : super(key: key);

  @override
  _RoadmapDetailScreenState createState() => _RoadmapDetailScreenState();
}

class _RoadmapDetailScreenState extends State<RoadmapDetailScreen> {
  final _userService = FirestoreUserService();
  bool _isLoading = false;
  bool _isInProfile = false;

  @override
  void initState() {
    super.initState();
    _checkRoadmapStatus();
  }

  Future<void> _checkRoadmapStatus() async {
    final isInProfile = await _userService.hasRoadmap(widget.roadmap.id);
    if (mounted) {
      setState(() => _isInProfile = isInProfile);
    }
  }

  Future<void> _toggleRoadmap() async {
    setState(() => _isLoading = true);
    try {
      if (_isInProfile) {
        await _userService.removeRoadmap(widget.roadmap.id);
      } else {
        await _userService.addRoadmap(widget.roadmap.id);
      }
      if (mounted) {
        setState(() => _isInProfile = !_isInProfile);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isInProfile
                  ? 'Added to your profile'
                  : 'Removed from your profile',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roadmap.title),
        actions: [
          IconButton(
            icon: Icon(_isInProfile ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _isLoading ? null : _toggleRoadmap,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.roadmap.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement start roadmap logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Starting roadmap...')),
                    );
                  },
                  child: const Text('Start Roadmap'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.roadmap.stages.length,
              itemBuilder: (context, index) {
                return RoadmapStageWidget(
                  stage: widget.roadmap.stages[index],
                  stageNumber: index + 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
