// filepath: lib/features/profile/screens/enrolled_roadmap_screen.dart

import 'package:flutter/material.dart';
import 'package:skillup/domain/entities/roadmap.dart';
import 'package:skillup/domain/entities/user_roadmap.dart';
import 'package:skillup/domain/entities/user_roadmap_progress.dart';
import 'package:skillup/features/explore/providers/sample_roadmap_data.dart';
import 'module_detail_screen.dart';
import '../services/firestore_user_service.dart';

/// Screen that shows detailed view of a roadmap the user has enrolled in.
/// Uses mock data for display and includes helper functions to compute
/// progress and derived metrics.
class EnrolledRoadmapScreen extends StatefulWidget {
  final Roadmap roadmap;
  final UserRoadmap? userRoadmap;

  const EnrolledRoadmapScreen({super.key, required this.roadmap, this.userRoadmap});

  @override
  State<EnrolledRoadmapScreen> createState() => _EnrolledRoadmapScreenState();
}

class _EnrolledRoadmapScreenState extends State<EnrolledRoadmapScreen> {
  late UserRoadmapProgress _progress;

  @override
  void initState() {
    super.initState();
    _progress = _buildMockProgress();
  }

  // Mock: build a fake UserRoadmapProgress for demo purposes. In real app
  // this would be loaded from a repository/service.
  UserRoadmapProgress _buildMockProgress() {
    final roadmap = widget.roadmap;
    // Use sample modules to assemble progress
    final modules = SampleRoadmapData.getSampleModulesList()
        .where((m) => roadmap.moduleIds.contains(m.id))
        .toList();

    final moduleProgress = <String, ModuleProgress>{};
    for (var m in modules) {
      final stageProgress = <String, StageProgress>{};
      for (var s in m.stages) {
        final taskMap = <String, TaskProgress>{};
        for (var t in s.tasks) {
          // randomly mark some tasks complete to simulate progress
          final completed = t.id.hashCode % 3 == 0;
          taskMap[t.id] = TaskProgress(
            taskId: t.id,
            isCompleted: completed,
            completedAt: completed ? DateTime.now().subtract(Duration(days: t.order)) : null,
            timeSpentMinutes: completed ? (t.estimatedMinutes ~/ 2) : 0,
            completedResourceIds: completed ? ['res_${t.id}'] : [],
          );
        }

        final completedTasks = taskMap.values.where((tp) => tp.isCompleted).length;
        final totalTasks = s.tasks.length;
        final pct = totalTasks == 0 ? 0.0 : (completedTasks / totalTasks) * 100.0;

        stageProgress[s.id] = StageProgress(
          stageId: s.id,
          startedAt: DateTime.now().subtract(const Duration(days: 10)),
          completedAt: completedTasks == totalTasks ? DateTime.now().subtract(const Duration(days: 1)) : null,
          progressPercentage: pct,
          completedTasks: completedTasks,
          totalTasks: totalTasks,
          taskProgress: taskMap,
          status: completedTasks == 0 ? StageStatus.notStarted : (completedTasks == totalTasks ? StageStatus.completed : StageStatus.inProgress),
        );
      }

      final completedStages = stageProgress.values.where((sp) => sp.status == StageStatus.completed).length;
      final totalStages = m.stages.length;
      final completedTasksSum = stageProgress.values.fold<int>(0, (p, e) => p + e.completedTasks);
      final totalTasksSum = stageProgress.values.fold<int>(0, (p, e) => p + e.totalTasks);
      final modulePct = totalTasksSum == 0 ? 0.0 : (completedTasksSum / totalTasksSum) * 100.0;

      moduleProgress[m.id] = ModuleProgress(
        moduleId: m.id,
        startedAt: DateTime.now().subtract(const Duration(days: 12)),
        completedAt: completedStages == totalStages ? DateTime.now().subtract(const Duration(days: 1)) : null,
        progressPercentage: modulePct,
        completedStages: completedStages,
        totalStages: totalStages,
        completedTasks: completedTasksSum,
        totalTasks: totalTasksSum,
        stageProgress: stageProgress,
        status: completedStages == 0 ? ModuleStatus.notStarted : (completedStages == totalStages ? ModuleStatus.completed : ModuleStatus.inProgress),
      );
    }

    final completedTasksTotal = moduleProgress.values.fold<int>(0, (p, e) => p + e.completedTasks);
    final totalTasksTotal = moduleProgress.values.fold<int>(0, (p, e) => p + e.totalTasks);
    final overallPct = totalTasksTotal == 0 ? 0.0 : (completedTasksTotal / totalTasksTotal) * 100.0;

    return UserRoadmapProgress(
      id: 'mock_${roadmap.id}',
      userId: 'mock_user',
      roadmapId: roadmap.id,
      startedAt: DateTime.now().subtract(const Duration(days: 15)),
      lastAccessedAt: DateTime.now(),
      progressPercentage: overallPct,
      completedTasks: completedTasksTotal,
      totalTasks: totalTasksTotal,
      moduleProgress: moduleProgress,
      status: overallPct >= 100.0 ? RoadmapStatus.completed : RoadmapStatus.inProgress,
      totalTimeSpentMinutes: moduleProgress.values.fold<int>(0, (p, m) => p + m.stageProgress.values.fold<int>(0, (pp, sp) => pp + sp.taskProgress.values.fold<int>(0, (ppp, tp) => ppp + tp.timeSpentMinutes))),
      currentModuleId: roadmap.moduleIds.isNotEmpty ? roadmap.moduleIds.first : null,
    );
  }

  // Helpers
  String _formatPercent(double pct) => '${pct.clamp(0.0, 100.0).toStringAsFixed(0)}%';

  String _formatHrs(int minutes) {
    if (minutes <= 0) return '0m';
    final hrs = minutes ~/ 60;
    final mins = minutes % 60;
    if (hrs > 0) return '${hrs}h ${mins}m';
    return '${mins}m';
  }

  Widget _buildOverview(BuildContext context) {
    final progress = _progress;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 28, child: Text(_formatPercent(progress.progressPercentage))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.roadmap.title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(value: (progress.progressPercentage / 100.0).clamp(0.0, 1.0)),
                      const SizedBox(height: 6),
                      Text('${progress.completedTasks}/${progress.totalTasks} tasks • ${_formatHrs(progress.totalTimeSpentMinutes)}'),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleList(BuildContext context) {
    final modules = _progress.moduleProgress.values.toList();
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: modules.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, idx) {
        final m = modules[idx];
        return Card(
          child: ListTile(
            title: Text(SampleRoadmapData.getSampleModuleById(m.moduleId)?.title ?? m.moduleId),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                LinearProgressIndicator(value: (m.progressPercentage / 100.0).clamp(0.0, 1.0)),
                const SizedBox(height: 6),
                Text('${m.completedStages}/${m.totalStages} stages • ${m.completedTasks}/${m.totalTasks} tasks'),
              ],
            ),
            trailing: Text(_formatPercent(m.progressPercentage)),
            onTap: () async {
              // Open module detail and await updated progress
              final updated = await Navigator.of(context).push<UserRoadmapProgress>(
                MaterialPageRoute(
                  builder: (_) => ModuleDetailScreen(
                    moduleId: m.moduleId,
                    moduleProgress: m,
                    updateTaskCallback: (String moduleId, String stageId, String taskId, bool isCompleted) async {
                      // Use _progress.updateTaskStatus to compute new progress and return it
                      final newProgress = _progress.updateTaskStatus(
                        moduleId: moduleId,
                        stageId: stageId,
                        taskId: taskId,
                        isCompleted: isCompleted,
                        timeSpentMinutes: isCompleted ? 5 : 0,
                      );
                      // Persist the updated progress so other screens see the change.
                      try {
                        await FirestoreUserService().saveUserRoadmapProgress(newProgress);
                      } catch (_) {
                        // ignore persistence errors in mock/demo mode
                      }
                      if (!mounted) return newProgress;
                      setState(() {
                        _progress = newProgress;
                      });
                      return newProgress;
                    },
                  ),
                ),
              );

              if (updated != null) {
                if (!mounted) return; // safety
                setState(() {
                  _progress = updated;
                });
                // try to persist final updated state
                try {
                  await FirestoreUserService().saveUserRoadmapProgress(updated);
                } catch (_) {}
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roadmap.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverview(context),
              const SizedBox(height: 12),
              Text('Modules', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              _buildModuleList(context),
            ],
          ),
        ),
      ),
    );
  }
}
