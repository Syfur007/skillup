import 'package:flutter/material.dart';
import 'package:skillup/features/explore/providers/sample_roadmap_data.dart';
import 'package:skillup/features/explore/widgets/roadmap_stage_expanded.dart';

class ModuleScreen extends StatelessWidget {
  final String moduleId;

  const ModuleScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    final module = SampleRoadmapData.getSampleModuleById(moduleId);

    if (module == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Module')),
        body: Center(child: Text('Module not found: $moduleId')),
      );
    }

    final totalTasks = module.stages.fold<int>(0, (prev, s) => prev + s.tasks.length);
    final totalResources = module.stages.fold<int>(0, (prev, s) => prev + s.resources.length);

    return Scaffold(
      appBar: AppBar(
        title: Text(module.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      if (module.imageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            module.imageUrl!,
                            width: 96,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          width: 96,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Icon(Icons.school, color: Theme.of(context).primaryColor),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(module.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(module.description, style: Theme.of(context).textTheme.bodyMedium, maxLines: 3, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _smallStat(context, Icons.layers, '${module.totalStages} stages'),
                                const SizedBox(width: 8),
                                _smallStat(context, Icons.task, '$totalTasks tasks'),
                                const SizedBox(width: 8),
                                _smallStat(context, Icons.book, '$totalResources resources'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Stages
            ...module.stages.map((s) {
              return RoadmapStageExpanded(
                stageTitle: s.title,
                stageDescription: s.description,
                taskCount: s.tasks.length,
                resourceCount: s.resources.length,
                estimatedMinutes: s.estimatedMinutes,
                isOptional: s.isOptional,
                tasks: s.tasks.map((t) => {
                      'title': t.title,
                      'description': t.description,
                      'type': t.taskType,
                      'points': t.points,
                    }).toList(),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _smallStat(BuildContext context, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).primaryColor),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
