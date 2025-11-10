// filepath: lib/features/profile/screens/enrolled_roadmap_screen.dart

import 'package:flutter/material.dart';
import 'package:skillup/domain/entities/roadmap.dart';
import 'package:skillup/domain/entities/module.dart';
import 'package:skillup/domain/entities/user_roadmap.dart';
import 'package:skillup/domain/entities/user_roadmap_progress.dart';
import 'package:skillup/features/explore/services/firestore_module_service.dart';
import 'package:skillup/core/utils/progress_calculator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'module_detail_screen.dart';
import '../services/firestore_user_service.dart';

/// Screen that shows detailed view of a roadmap the user has enrolled in.
/// Fetches module data from Firestore and displays real progress information.
class EnrolledRoadmapScreen extends StatefulWidget {
  final Roadmap roadmap;
  final UserRoadmap? userRoadmap;

  const EnrolledRoadmapScreen({super.key, required this.roadmap, this.userRoadmap});

  @override
  State<EnrolledRoadmapScreen> createState() => _EnrolledRoadmapScreenState();
}

class _EnrolledRoadmapScreenState extends State<EnrolledRoadmapScreen> {
  final _moduleService = FirestoreModuleService();
  final _userService = FirestoreUserService();
  late UserRoadmapProgress _progress;
  List<Module> _modules = [];
  bool _loadingModules = true;

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    setState(() => _loadingModules = true);
    try {
      final modules = <Module>[];
      for (final moduleId in widget.roadmap.moduleIds) {
        final module = await _moduleService.getModuleById(moduleId);
        if (module != null) {
          modules.add(module);
        }
      }
      if (!mounted) return;
      setState(() {
        _modules = modules;
        _loadingModules = false;
        _progress = _buildRealProgress();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingModules = false;
        _progress = _buildRealProgress();
      });
    }
  }

  // Build real UserRoadmapProgress from loaded modules and user data
  UserRoadmapProgress _buildRealProgress() {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';

    return ProgressCalculator.buildProgressFromModules(
      roadmapId: widget.roadmap.id,
      userId: userId,
      modules: _modules,
      userRoadmap: widget.userRoadmap,
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
        final moduleData = _modules.firstWhere((mod) => mod.id == m.moduleId, orElse: () => Module(id: m.moduleId, title: m.moduleId, description: '', createdBy: ''));
        return Card(
          child: ListTile(
            title: Text(moduleData.title),
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
                      // Use ProgressCalculator to compute new progress
                      final newProgress = ProgressCalculator.updateTaskCompletion(
                        currentProgress: _progress,
                        moduleId: moduleId,
                        stageId: stageId,
                        taskId: taskId,
                        isCompleted: isCompleted,
                      );

                      // Persist the updated progress to Firestore
                      try {
                        await _userService.saveUserRoadmapProgress(newProgress);
                      } catch (e) {
                        // Log error but continue - UI will still update locally
                        debugPrint('Failed to save progress: $e');
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
                if (!mounted) return;
                setState(() {
                  _progress = updated;
                });
                // Persist final state
                try {
                  await _userService.saveUserRoadmapProgress(updated);
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
      body: _loadingModules
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () async {
          await _loadModules();
        },
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
