// roadmap_detail_screen.dart
// Screen that shows detailed information about a single roadmap. Should accept
// a Roadmap entity and render its content.

// Placeholder: implement RoadmapDetailScreen widget here.

import 'package:flutter/material.dart';
import '../models/roadmap.dart';
import '../widgets/roadmap_stage_widget.dart';

class RoadmapDetailScreen extends StatelessWidget {
  final Roadmap roadmap;

  const RoadmapDetailScreen({Key? key, required this.roadmap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(roadmap.title)),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  roadmap.description,
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
              itemCount: roadmap.stages.length,
              itemBuilder: (context, index) {
                return RoadmapStageWidget(
                  stage: roadmap.stages[index],
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
