// filepath: lib/core/utils/progress_calculator.dart
// Utility class for calculating progress across roadmaps, modules, stages, and tasks
// This centralizes all progress calculation logic for consistency

import 'package:skillup/domain/entities/module.dart';
import 'package:skillup/domain/entities/roadmap.dart';
import 'package:skillup/domain/entities/user_roadmap.dart';
import 'package:skillup/domain/entities/user_roadmap_progress.dart';

/// Centralized progress calculation utility
///
/// This class provides consistent progress calculation across the app.
/// It uses a hierarchical approach:
/// - Task completion is tracked as boolean (completed/not completed)
/// - Stage progress = completed tasks / total tasks in stage
/// - Module progress = completed tasks / total tasks in module
/// - Roadmap progress = completed tasks / total tasks in roadmap
class ProgressCalculator {
  /// Calculate stage progress from task completions
  ///
  /// Returns a value between 0.0 and 1.0
  static double calculateStageProgress(StageProgress stageProgress) {
    if (stageProgress.totalTasks == 0) return 0.0;

    final completed = stageProgress.taskProgress.values
        .where((tp) => tp.isCompleted)
        .length;

    return (completed / stageProgress.totalTasks).clamp(0.0, 1.0);
  }

  /// Calculate module progress from all stage progressions
  ///
  /// Returns a value between 0.0 and 1.0
  static double calculateModuleProgress(ModuleProgress moduleProgress) {
    if (moduleProgress.totalTasks == 0) return 0.0;

    final completed = moduleProgress.stageProgress.values
        .expand((sp) => sp.taskProgress.values)
        .where((tp) => tp.isCompleted)
        .length;

    return (completed / moduleProgress.totalTasks).clamp(0.0, 1.0);
  }

  /// Calculate roadmap progress from all module progressions
  ///
  /// Returns a value between 0.0 and 1.0
  static double calculateRoadmapProgress(UserRoadmapProgress roadmapProgress) {
    if (roadmapProgress.totalTasks == 0) return 0.0;

    final completed = roadmapProgress.moduleProgress.values
        .expand((mp) => mp.stageProgress.values)
        .expand((sp) => sp.taskProgress.values)
        .where((tp) => tp.isCompleted)
        .length;

    return (completed / roadmapProgress.totalTasks).clamp(0.0, 1.0);
  }

  /// Build UserRoadmapProgress from modules and user data
  ///
  /// This creates a complete progress structure from loaded modules
  /// and existing completion data
  static UserRoadmapProgress buildProgressFromModules({
    required String roadmapId,
    required String userId,
    required List<Module> modules,
    required UserRoadmap? userRoadmap,
  }) {
    final moduleProgressMap = <String, ModuleProgress>{};
    int totalTasks = 0;
    int completedTasks = 0;

    for (final module in modules) {
      final stageProgressMap = <String, StageProgress>{};
      int moduleTotalTasks = 0;
      int moduleCompletedTasks = 0;

      for (final stage in module.stages) {
        final taskProgressMap = <String, TaskProgress>{};
        int stageTotalTasks = stage.tasks.length;
        int stageCompletedTasks = 0;

        for (final task in stage.tasks) {
          // Check if task is completed in user data
          final isCompleted = userRoadmap?.completedSteps[task.id] ?? false;

          taskProgressMap[task.id] = TaskProgress(
            taskId: task.id,
            isCompleted: isCompleted,
            completedAt: isCompleted ? DateTime.now() : null,
            timeSpentMinutes: 0,
          );

          if (isCompleted) {
            stageCompletedTasks++;
            moduleCompletedTasks++;
            completedTasks++;
          }
        }

        moduleTotalTasks += stageTotalTasks;
        totalTasks += stageTotalTasks;

        final stageProgressPct = stageTotalTasks == 0
            ? 0.0
            : (stageCompletedTasks / stageTotalTasks) * 100.0;

        stageProgressMap[stage.id] = StageProgress(
          stageId: stage.id,
          startedAt: stageCompletedTasks > 0 ? DateTime.now() : null,
          completedAt: stageCompletedTasks == stageTotalTasks ? DateTime.now() : null,
          progressPercentage: stageProgressPct,
          completedTasks: stageCompletedTasks,
          totalTasks: stageTotalTasks,
          taskProgress: taskProgressMap,
          status: _determineStageStatus(stageCompletedTasks, stageTotalTasks),
        );
      }

      final moduleProgressPct = moduleTotalTasks == 0
          ? 0.0
          : (moduleCompletedTasks / moduleTotalTasks) * 100.0;

      moduleProgressMap[module.id] = ModuleProgress(
        moduleId: module.id,
        startedAt: moduleCompletedTasks > 0 ? DateTime.now() : null,
        completedAt: moduleCompletedTasks == moduleTotalTasks && moduleTotalTasks > 0
            ? DateTime.now()
            : null,
        progressPercentage: moduleProgressPct,
        completedStages: module.stages.where((s) {
          final sp = stageProgressMap[s.id];
          return sp != null && sp.status == StageStatus.completed;
        }).length,
        totalStages: module.stages.length,
        completedTasks: moduleCompletedTasks,
        totalTasks: moduleTotalTasks,
        stageProgress: stageProgressMap,
        status: _determineModuleStatus(moduleCompletedTasks, moduleTotalTasks),
      );
    }

    final overallProgressPct = totalTasks == 0
        ? 0.0
        : (completedTasks / totalTasks) * 100.0;

    return UserRoadmapProgress(
      id: '${userId}_$roadmapId',
      userId: userId,
      roadmapId: roadmapId,
      startedAt: userRoadmap?.startedAt ?? DateTime.now(),
      lastAccessedAt: DateTime.now(),
      progressPercentage: overallProgressPct,
      completedTasks: completedTasks,
      totalTasks: totalTasks,
      moduleProgress: moduleProgressMap,
      status: _determineRoadmapStatus(completedTasks, totalTasks),
      totalTimeSpentMinutes: 0,
      currentModuleId: modules.isNotEmpty ? modules.first.id : null,
    );
  }

  /// Update a single task's completion status
  ///
  /// Returns updated UserRoadmapProgress with recalculated progress values
  static UserRoadmapProgress updateTaskCompletion({
    required UserRoadmapProgress currentProgress,
    required String moduleId,
    required String stageId,
    required String taskId,
    required bool isCompleted,
  }) {
    // Deep copy the progress structure
    final updatedModuleProgress = Map<String, ModuleProgress>.from(
      currentProgress.moduleProgress,
    );

    final module = updatedModuleProgress[moduleId];
    if (module == null) return currentProgress;

    final updatedStageProgress = Map<String, StageProgress>.from(
      module.stageProgress,
    );

    final stage = updatedStageProgress[stageId];
    if (stage == null) return currentProgress;

    final updatedTaskProgress = Map<String, TaskProgress>.from(
      stage.taskProgress,
    );

    final task = updatedTaskProgress[taskId];
    if (task == null) return currentProgress;

    // Update task completion
    updatedTaskProgress[taskId] = task.copyWith(
      isCompleted: isCompleted,
      completedAt: isCompleted ? DateTime.now() : null,
    );

    // Recalculate stage progress
    final stageCompletedTasks = updatedTaskProgress.values
        .where((tp) => tp.isCompleted)
        .length;
    final stageTotalTasks = updatedTaskProgress.length;
    final stageProgressPct = stageTotalTasks == 0
        ? 0.0
        : (stageCompletedTasks / stageTotalTasks) * 100.0;

    updatedStageProgress[stageId] = stage.copyWith(
      taskProgress: updatedTaskProgress,
      completedTasks: stageCompletedTasks,
      totalTasks: stageTotalTasks,
      progressPercentage: stageProgressPct,
      status: _determineStageStatus(stageCompletedTasks, stageTotalTasks),
      startedAt: stage.startedAt ?? (stageCompletedTasks > 0 ? DateTime.now() : null),
      completedAt: stageCompletedTasks == stageTotalTasks ? DateTime.now() : null,
    );

    // Recalculate module progress
    final moduleCompletedTasks = updatedStageProgress.values
        .fold<int>(0, (sum, sp) => sum + sp.completedTasks);
    final moduleTotalTasks = updatedStageProgress.values
        .fold<int>(0, (sum, sp) => sum + sp.totalTasks);
    final moduleProgressPct = moduleTotalTasks == 0
        ? 0.0
        : (moduleCompletedTasks / moduleTotalTasks) * 100.0;

    updatedModuleProgress[moduleId] = module.copyWith(
      stageProgress: updatedStageProgress,
      completedTasks: moduleCompletedTasks,
      totalTasks: moduleTotalTasks,
      progressPercentage: moduleProgressPct,
      status: _determineModuleStatus(moduleCompletedTasks, moduleTotalTasks),
      startedAt: module.startedAt ?? (moduleCompletedTasks > 0 ? DateTime.now() : null),
      completedAt: moduleCompletedTasks == moduleTotalTasks && moduleTotalTasks > 0
          ? DateTime.now()
          : null,
    );

    // Recalculate overall roadmap progress
    final totalCompletedTasks = updatedModuleProgress.values
        .fold<int>(0, (sum, mp) => sum + mp.completedTasks);
    final totalTasks = updatedModuleProgress.values
        .fold<int>(0, (sum, mp) => sum + mp.totalTasks);
    final overallProgressPct = totalTasks == 0
        ? 0.0
        : (totalCompletedTasks / totalTasks) * 100.0;

    return currentProgress.copyWith(
      moduleProgress: updatedModuleProgress,
      completedTasks: totalCompletedTasks,
      totalTasks: totalTasks,
      progressPercentage: overallProgressPct,
      lastAccessedAt: DateTime.now(),
      status: _determineRoadmapStatus(totalCompletedTasks, totalTasks),
    );
  }

  /// Normalize progress value to 0.0-1.0 range
  ///
  /// Handles both fraction (0.0-1.0) and percentage (0-100) formats
  static double normalizeProgress(double raw) {
    if (raw > 0.0) {
      if (raw > 1.0) {
        // Treat values > 1.0 as percentage (0-100)
        return (raw.clamp(0.0, 100.0) / 100.0).clamp(0.0, 1.0);
      }
      // Already a fraction (0.0-1.0)
      return raw.clamp(0.0, 1.0);
    }
    return 0.0;
  }

  /// Get progress from UserRoadmap with fallback calculation
  ///
  /// Priority:
  /// 1. Use stored progress value if > 0
  /// 2. Calculate from completedSteps / roadmap.totalTasks
  /// 3. Return 0.0 if no data available
  static double getProgressFromUserRoadmap({
    required UserRoadmap userRoadmap,
    Roadmap? roadmap,
  }) {
    // Try stored progress first
    final raw = userRoadmap.progress;
    if (raw > 0.0) {
      return normalizeProgress(raw);
    }

    // Fallback: calculate from completedSteps
    if (roadmap != null && roadmap.totalTasks > 0) {
      final completed = userRoadmap.completedSteps.values
          .where((v) => v == true)
          .length;
      return (completed / roadmap.totalTasks).clamp(0.0, 1.0);
    }

    return 0.0;
  }

  /// Extract completed steps map from UserRoadmapProgress
  ///
  /// This creates a flat map of taskId -> completion status
  /// for efficient storage in Firestore
  static Map<String, bool> extractCompletedSteps(
    UserRoadmapProgress progress,
  ) {
    final completedSteps = <String, bool>{};

    for (final module in progress.moduleProgress.values) {
      for (final stage in module.stageProgress.values) {
        for (final task in stage.taskProgress.values) {
          completedSteps[task.taskId] = task.isCompleted;
        }
      }
    }

    return completedSteps;
  }

  // Private helper methods

  static StageStatus _determineStageStatus(int completed, int total) {
    if (total == 0) return StageStatus.notStarted;
    if (completed == 0) return StageStatus.notStarted;
    if (completed == total) return StageStatus.completed;
    return StageStatus.inProgress;
  }

  static ModuleStatus _determineModuleStatus(int completed, int total) {
    if (total == 0) return ModuleStatus.notStarted;
    if (completed == 0) return ModuleStatus.notStarted;
    if (completed == total) return ModuleStatus.completed;
    return ModuleStatus.inProgress;
  }

  static RoadmapStatus _determineRoadmapStatus(int completed, int total) {
    if (total == 0) return RoadmapStatus.notStarted;
    if (completed == 0) return RoadmapStatus.notStarted;
    if (completed == total) return RoadmapStatus.completed;
    return RoadmapStatus.inProgress;
  }
}

