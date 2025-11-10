// filepath: lib/features/profile/screens/module_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:skillup/domain/entities/user_roadmap_progress.dart';
import 'package:skillup/features/explore/providers/sample_roadmap_data.dart';

typedef UpdateTaskCallback = Future<UserRoadmapProgress> Function(
  String moduleId,
  String stageId,
  String taskId,
  bool isCompleted,
);

class ModuleDetailScreen extends StatefulWidget {
  final String moduleId;
  final ModuleProgress moduleProgress;
  final UpdateTaskCallback updateTaskCallback;

  const ModuleDetailScreen({super.key, required this.moduleId, required this.moduleProgress, required this.updateTaskCallback});

  @override
  State<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen> {
  late ModuleProgress _moduleProgress;
  UserRoadmapProgress? _latestProgress;

  @override
  void initState() {
    super.initState();
    // Make a local mutable copy (use copyWith if available) - for simplicity clone fields
    _moduleProgress = widget.moduleProgress.copyWith(
      stageProgress: Map<String, StageProgress>.from(widget.moduleProgress.stageProgress),
    );
  }

  Future<void> _toggleTask(String stageId, String taskId, bool newValue) async {
    try {
      // Call the callback to compute updated global progress (and allow persistence)
      final updated = await widget.updateTaskCallback(widget.moduleId, stageId, taskId, newValue);
      // If the widget was disposed while awaiting, abort - do not touch context
      if (!mounted) return;

      // Keep the latest returned object so we can return it when popping
      _latestProgress = updated;

      // If returned progress contains module info, update local module view
      final m = updated.moduleProgress[widget.moduleId];
      if (m != null) {
        setState(() {
          _moduleProgress = m;
        });
      } else {
        // Fallback: try to update only the local stage/task flags
        final sp = _moduleProgress.stageProgress[stageId];
        if (sp != null) {
          final clonedTasks = Map<String, TaskProgress>.from(sp.taskProgress);
          final orig = clonedTasks[taskId];
          if (orig != null) {
            clonedTasks[taskId] = orig.copyWith(isCompleted: newValue, completedAt: newValue ? DateTime.now() : null);
          } else {
            clonedTasks[taskId] = TaskProgress(taskId: taskId, isCompleted: newValue, completedAt: newValue ? DateTime.now() : null);
          }
          final completedTasksCount = clonedTasks.values.where((t) => t.isCompleted).length;
          final totalTasksCount = clonedTasks.length;
          final pct = totalTasksCount == 0 ? 0.0 : (completedTasksCount / totalTasksCount) * 100.0;
          if (!mounted) return; // double-check before mutating state
          setState(() {
            final newStages = Map<String, StageProgress>.from(_moduleProgress.stageProgress);
            newStages[stageId] = sp.copyWith(
              taskProgress: clonedTasks,
              completedTasks: completedTasksCount,
              totalTasks: totalTasksCount,
              progressPercentage: pct,
              status: completedTasksCount == 0 ? StageStatus.notStarted : (completedTasksCount == totalTasksCount ? StageStatus.completed : StageStatus.inProgress),
            );
            _moduleProgress = _moduleProgress.copyWith(stageProgress: newStages);
          });
        }
      }

      if (!mounted) return; // ensure context valid before using it
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task updated')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update task: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final module = SampleRoadmapData.getSampleModuleById(widget.moduleId);
    final stages = module?.stages ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(module?.title ?? widget.moduleId),
        actions: [
          IconButton(
            tooltip: 'Done',
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop(_latestProgress);
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, idx) {
          final stage = stages[idx];
          final sp = _moduleProgress.stageProgress[stage.id];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(stage.title, style: Theme.of(context).textTheme.titleMedium),
                      Text('${sp?.completedTasks ?? 0}/${sp?.totalTasks ?? stage.tasks.length}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...stage.tasks.map((t) {
                    final tp = sp?.taskProgress[t.id];
                    final isCompleted = tp?.isCompleted ?? false;
                    return ListTile(
                      title: Text(t.title),
                      subtitle: Text('${t.estimatedMinutes} min'),
                      trailing: Checkbox(
                        value: isCompleted,
                        onChanged: (v) => _toggleTask(stage.id, t.id, v ?? false),
                      ),
                      // Intentionally do not handle onTap to avoid duplicate toggle events
                      onTap: null,
                    );
                  }),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemCount: stages.length,
      ),
    );
  }
}
