// filepath: lib/domain/entities/user_roadmap_progress.dart

// Entities that model a user's progress/enrollment in a roadmap.
// Matches the structures described in skillup_models.md.

enum RoadmapStatus {
  notStarted,
  inProgress,
  completed,
  paused;

  String toJson() => name;
  static RoadmapStatus fromJson(String v) => RoadmapStatus.values.firstWhere(
        (e) => e.name == v,
        orElse: () => RoadmapStatus.notStarted,
      );
}

enum ModuleStatus {
  notStarted,
  inProgress,
  completed,
  skipped;

  String toJson() => name;
  static ModuleStatus fromJson(String v) => ModuleStatus.values.firstWhere(
        (e) => e.name == v,
        orElse: () => ModuleStatus.notStarted,
      );
}

enum StageStatus {
  notStarted,
  inProgress,
  completed,
  skipped;

  String toJson() => name;
  static StageStatus fromJson(String v) => StageStatus.values.firstWhere(
        (e) => e.name == v,
        orElse: () => StageStatus.notStarted,
      );
}

class TaskProgress {
  final String taskId;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? notes;
  final List<String> completedResourceIds;
  final int timeSpentMinutes;

  TaskProgress({
    required this.taskId,
    this.isCompleted = false,
    this.completedAt,
    this.notes,
    List<String>? completedResourceIds,
    this.timeSpentMinutes = 0,
  }) : completedResourceIds = completedResourceIds ?? [];

  TaskProgress copyWith({
    String? taskId,
    bool? isCompleted,
    DateTime? completedAt,
    String? notes,
    List<String>? completedResourceIds,
    int? timeSpentMinutes,
  }) {
    return TaskProgress(
      taskId: taskId ?? this.taskId,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      completedResourceIds: completedResourceIds ?? this.completedResourceIds,
      timeSpentMinutes: timeSpentMinutes ?? this.timeSpentMinutes,
    );
  }

  Map<String, dynamic> toJson() => {
        'taskId': taskId,
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
        'notes': notes,
        'completedResourceIds': completedResourceIds,
        'timeSpentMinutes': timeSpentMinutes,
      };

  factory TaskProgress.fromJson(Map<String, dynamic> json) => TaskProgress(
        taskId: json['taskId'] as String,
        isCompleted: json['isCompleted'] as bool? ?? false,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
        notes: json['notes'] as String?,
        completedResourceIds: (json['completedResourceIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        timeSpentMinutes: json['timeSpentMinutes'] as int? ?? 0,
      );
}

class StageProgress {
  final String stageId;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final double progressPercentage;
  final int completedTasks;
  final int totalTasks;
  final Map<String, TaskProgress> taskProgress;
  final int completedQuizzes;
  final int totalQuizzes;
  final StageStatus status;

  StageProgress({
    required this.stageId,
    this.startedAt,
    this.completedAt,
    this.progressPercentage = 0.0,
    this.completedTasks = 0,
    this.totalTasks = 0,
    Map<String, TaskProgress>? taskProgress,
    this.completedQuizzes = 0,
    this.totalQuizzes = 0,
    this.status = StageStatus.notStarted,
  }) : taskProgress = taskProgress ?? {};

  StageProgress copyWith({
    String? stageId,
    DateTime? startedAt,
    DateTime? completedAt,
    double? progressPercentage,
    int? completedTasks,
    int? totalTasks,
    Map<String, TaskProgress>? taskProgress,
    int? completedQuizzes,
    int? totalQuizzes,
    StageStatus? status,
  }) {
    return StageProgress(
      stageId: stageId ?? this.stageId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      completedTasks: completedTasks ?? this.completedTasks,
      totalTasks: totalTasks ?? this.totalTasks,
      taskProgress: taskProgress ?? this.taskProgress,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes,
      totalQuizzes: totalQuizzes ?? this.totalQuizzes,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
        'stageId': stageId,
        'startedAt': startedAt?.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'progressPercentage': progressPercentage,
        'completedTasks': completedTasks,
        'totalTasks': totalTasks,
        'taskProgress': taskProgress.map((k, v) => MapEntry(k, v.toJson())),
        'completedQuizzes': completedQuizzes,
        'totalQuizzes': totalQuizzes,
        'status': status.toJson(),
      };

  factory StageProgress.fromJson(Map<String, dynamic> json) => StageProgress(
        stageId: json['stageId'] as String,
        startedAt: json['startedAt'] != null
            ? DateTime.parse(json['startedAt'] as String)
            : null,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
        progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
        completedTasks: json['completedTasks'] as int? ?? 0,
        totalTasks: json['totalTasks'] as int? ?? 0,
        taskProgress: (json['taskProgress'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, TaskProgress.fromJson(v as Map<String, dynamic>))) ??
            {},
        completedQuizzes: json['completedQuizzes'] as int? ?? 0,
        totalQuizzes: json['totalQuizzes'] as int? ?? 0,
        status: json['status'] != null
            ? StageStatus.fromJson(json['status'] as String)
            : StageStatus.notStarted,
      );
}

class ModuleProgress {
  final String moduleId;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final double progressPercentage;
  final int completedStages;
  final int totalStages;
  final int completedTasks;
  final int totalTasks;
  final Map<String, StageProgress> stageProgress;
  final ModuleStatus status;

  ModuleProgress({
    required this.moduleId,
    this.startedAt,
    this.completedAt,
    this.progressPercentage = 0.0,
    this.completedStages = 0,
    this.totalStages = 0,
    this.completedTasks = 0,
    this.totalTasks = 0,
    Map<String, StageProgress>? stageProgress,
    this.status = ModuleStatus.notStarted,
  }) : stageProgress = stageProgress ?? {};

  ModuleProgress copyWith({
    String? moduleId,
    DateTime? startedAt,
    DateTime? completedAt,
    double? progressPercentage,
    int? completedStages,
    int? totalStages,
    int? completedTasks,
    int? totalTasks,
    Map<String, StageProgress>? stageProgress,
    ModuleStatus? status,
  }) {
    return ModuleProgress(
      moduleId: moduleId ?? this.moduleId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      completedStages: completedStages ?? this.completedStages,
      totalStages: totalStages ?? this.totalStages,
      completedTasks: completedTasks ?? this.completedTasks,
      totalTasks: totalTasks ?? this.totalTasks,
      stageProgress: stageProgress ?? this.stageProgress,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
        'moduleId': moduleId,
        'startedAt': startedAt?.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'progressPercentage': progressPercentage,
        'completedStages': completedStages,
        'totalStages': totalStages,
        'completedTasks': completedTasks,
        'totalTasks': totalTasks,
        'stageProgress': stageProgress.map((k, v) => MapEntry(k, v.toJson())),
        'status': status.toJson(),
      };

  factory ModuleProgress.fromJson(Map<String, dynamic> json) => ModuleProgress(
        moduleId: json['moduleId'] as String,
        startedAt: json['startedAt'] != null
            ? DateTime.parse(json['startedAt'] as String)
            : null,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
        progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
        completedStages: json['completedStages'] as int? ?? 0,
        totalStages: json['totalStages'] as int? ?? 0,
        completedTasks: json['completedTasks'] as int? ?? 0,
        totalTasks: json['totalTasks'] as int? ?? 0,
        stageProgress: (json['stageProgress'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, StageProgress.fromJson(v as Map<String, dynamic>))) ??
            {},
        status: json['status'] != null
            ? ModuleStatus.fromJson(json['status'] as String)
            : ModuleStatus.notStarted,
      );
}

class UserRoadmapProgress {
  final String id;
  final String userId;
  final String roadmapId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final DateTime lastAccessedAt;
  final double progressPercentage;
  final int completedTasks;
  final int totalTasks;
  final Map<String, ModuleProgress> moduleProgress;
  final RoadmapStatus status;
  final int totalTimeSpentMinutes;
  final String? currentModuleId;
  final String? currentStageId;

  UserRoadmapProgress({
    required this.id,
    required this.userId,
    required this.roadmapId,
    DateTime? startedAt,
    this.completedAt,
    DateTime? lastAccessedAt,
    this.progressPercentage = 0.0,
    this.completedTasks = 0,
    this.totalTasks = 0,
    Map<String, ModuleProgress>? moduleProgress,
    this.status = RoadmapStatus.notStarted,
    this.totalTimeSpentMinutes = 0,
    this.currentModuleId,
    this.currentStageId,
  })  : startedAt = startedAt ?? DateTime.now(),
        lastAccessedAt = lastAccessedAt ?? DateTime.now(),
        moduleProgress = moduleProgress ?? {};

  UserRoadmapProgress copyWith({
    String? id,
    String? userId,
    String? roadmapId,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? lastAccessedAt,
    double? progressPercentage,
    int? completedTasks,
    int? totalTasks,
    Map<String, ModuleProgress>? moduleProgress,
    RoadmapStatus? status,
    int? totalTimeSpentMinutes,
    String? currentModuleId,
    String? currentStageId,
  }) {
    return UserRoadmapProgress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      roadmapId: roadmapId ?? this.roadmapId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      completedTasks: completedTasks ?? this.completedTasks,
      totalTasks: totalTasks ?? this.totalTasks,
      moduleProgress: moduleProgress ?? this.moduleProgress,
      status: status ?? this.status,
      totalTimeSpentMinutes: totalTimeSpentMinutes ?? this.totalTimeSpentMinutes,
      currentModuleId: currentModuleId ?? this.currentModuleId,
      currentStageId: currentStageId ?? this.currentStageId,
    );
  }

  /// Return a new [UserRoadmapProgress] with a single task updated.
  /// If the module/stage/task entries do not exist they will be created
  /// using sensible defaults (counts derived from existing maps).
  UserRoadmapProgress updateTaskStatus({
    required String moduleId,
    required String stageId,
    required String taskId,
    required bool isCompleted,
    int timeSpentMinutes = 0,
    DateTime? completedAt,
  }) {
    // Clone moduleProgress map and nested structures to avoid mutating original
    final newModuleProgress = <String, ModuleProgress>{};
    moduleProgress.forEach((k, v) => newModuleProgress[k] = v);

    final origModule = newModuleProgress[moduleId];

    if (origModule == null) {
      // Nothing to update if module is missing; create a minimal structure
      final newTask = TaskProgress(taskId: taskId, isCompleted: isCompleted, completedAt: isCompleted ? (completedAt ?? DateTime.now()) : null, timeSpentMinutes: timeSpentMinutes);
      final newStage = StageProgress(
        stageId: stageId,
        startedAt: DateTime.now(),
        completedAt: isCompleted ? (completedAt ?? DateTime.now()) : null,
        progressPercentage: isCompleted ? 100.0 : 0.0,
        completedTasks: isCompleted ? 1 : 0,
        totalTasks: 1,
        taskProgress: {taskId: newTask},
        status: isCompleted ? StageStatus.completed : StageStatus.notStarted,
      );
      final newModule = ModuleProgress(
        moduleId: moduleId,
        startedAt: DateTime.now(),
        completedAt: isCompleted ? (completedAt ?? DateTime.now()) : null,
        progressPercentage: isCompleted ? 100.0 : 0.0,
        completedStages: isCompleted ? 1 : 0,
        totalStages: 1,
        completedTasks: isCompleted ? 1 : 0,
        totalTasks: 1,
        stageProgress: {stageId: newStage},
        status: isCompleted ? ModuleStatus.completed : ModuleStatus.notStarted,
      );
      newModuleProgress[moduleId] = newModule;
    } else {
      // Clone existing module and its stages map
      final clonedStages = <String, StageProgress>{};
      origModule.stageProgress.forEach((k, v) => clonedStages[k] = v);

      final origStage = clonedStages[stageId];
      if (origStage == null) {
        // Create new stage entry
        final newTask = TaskProgress(taskId: taskId, isCompleted: isCompleted, completedAt: isCompleted ? (completedAt ?? DateTime.now()) : null, timeSpentMinutes: timeSpentMinutes);
        final newStage = StageProgress(
          stageId: stageId,
          startedAt: DateTime.now(),
          completedAt: isCompleted ? (completedAt ?? DateTime.now()) : null,
          progressPercentage: isCompleted ? 100.0 : 0.0,
          completedTasks: isCompleted ? 1 : 0,
          totalTasks: 1,
          taskProgress: {taskId: newTask},
          status: isCompleted ? StageStatus.completed : StageStatus.notStarted,
        );
        clonedStages[stageId] = newStage;
      } else {
        // Clone taskProgress map
        final clonedTasks = <String, TaskProgress>{};
        origStage.taskProgress.forEach((k, v) => clonedTasks[k] = v);

        final origTask = clonedTasks[taskId];
        if (origTask == null) {
          // Create a new task progress entry
          clonedTasks[taskId] = TaskProgress(
            taskId: taskId,
            isCompleted: isCompleted,
            completedAt: isCompleted ? (completedAt ?? DateTime.now()) : null,
            timeSpentMinutes: timeSpentMinutes,
            completedResourceIds: isCompleted ? ['res_$taskId'] : [],
          );
        } else {
          // Update existing task
          clonedTasks[taskId] = origTask.copyWith(
            isCompleted: isCompleted,
            completedAt: isCompleted ? (completedAt ?? DateTime.now()) : null,
            timeSpentMinutes: isCompleted ? (origTask.timeSpentMinutes + timeSpentMinutes) : (origTask.timeSpentMinutes),
          );
        }

        // Recompute stage aggregates
        final completedTasksCount = clonedTasks.values.where((t) => t.isCompleted).length;
        final totalTasksCount = clonedTasks.isNotEmpty ? clonedTasks.length : origStage.totalTasks;
        final pct = totalTasksCount == 0 ? 0.0 : (completedTasksCount / totalTasksCount) * 100.0;
        clonedStages[stageId] = origStage.copyWith(
          taskProgress: clonedTasks,
          completedTasks: completedTasksCount,
          totalTasks: totalTasksCount,
          progressPercentage: pct,
          status: completedTasksCount == 0 ? StageStatus.notStarted : (completedTasksCount == totalTasksCount ? StageStatus.completed : StageStatus.inProgress),
          completedAt: completedTasksCount == totalTasksCount ? (completedAt ?? DateTime.now()) : origStage.completedAt,
        );
      }

      // Recompute module aggregates based on clonedStages
      final completedStagesCount = clonedStages.values.where((s) => s.status == StageStatus.completed).length;
      final totalStagesCount = clonedStages.isNotEmpty ? clonedStages.length : origModule.totalStages;
      final completedTasksSum = clonedStages.values.fold<int>(0, (p, e) => p + e.completedTasks);
      final totalTasksSum = clonedStages.values.fold<int>(0, (p, e) => p + e.totalTasks);
      final modulePct = totalTasksSum == 0 ? 0.0 : (completedTasksSum / totalTasksSum) * 100.0;

      newModuleProgress[moduleId] = origModule.copyWith(
        stageProgress: clonedStages,
        completedStages: completedStagesCount,
        totalStages: totalStagesCount,
        completedTasks: completedTasksSum,
        totalTasks: totalTasksSum,
        progressPercentage: modulePct,
        status: completedStagesCount == 0 ? ModuleStatus.notStarted : (completedStagesCount == totalStagesCount ? ModuleStatus.completed : ModuleStatus.inProgress),
      );
    }

    // Recompute overall roadmap aggregates
    final newCompletedTasks = newModuleProgress.values.fold<int>(0, (p, m) => p + m.completedTasks);
    final newTotalTasks = newModuleProgress.values.fold<int>(0, (p, m) => p + m.totalTasks);
    final newTotalTime = newModuleProgress.values.fold<int>(0, (p, m) => p + m.stageProgress.values.fold<int>(0, (pp, sp) => pp + sp.taskProgress.values.fold<int>(0, (ppp, t) => ppp + t.timeSpentMinutes)));
    final newPct = newTotalTasks == 0 ? 0.0 : (newCompletedTasks / newTotalTasks) * 100.0;

    final newStatus = newPct >= 100.0 ? RoadmapStatus.completed : (newPct > 0.0 ? RoadmapStatus.inProgress : RoadmapStatus.notStarted);

    return copyWith(
      moduleProgress: newModuleProgress,
      completedTasks: newCompletedTasks,
      totalTasks: newTotalTasks,
      progressPercentage: newPct,
      status: newStatus,
      totalTimeSpentMinutes: newTotalTime,
      lastAccessedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'roadmapId': roadmapId,
        'startedAt': startedAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'lastAccessedAt': lastAccessedAt.toIso8601String(),
        'progressPercentage': progressPercentage,
        'completedTasks': completedTasks,
        'totalTasks': totalTasks,
        'moduleProgress': moduleProgress.map((k, v) => MapEntry(k, v.toJson())),
        'status': status.toJson(),
        'totalTimeSpentMinutes': totalTimeSpentMinutes,
        'currentModuleId': currentModuleId,
        'currentStageId': currentStageId,
      };

  factory UserRoadmapProgress.fromJson(Map<String, dynamic> json) => UserRoadmapProgress(
        id: json['id'] as String,
        userId: json['userId'] as String,
        roadmapId: json['roadmapId'] as String,
        startedAt: json['startedAt'] != null
            ? DateTime.parse(json['startedAt'] as String)
            : DateTime.now(),
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
        lastAccessedAt: json['lastAccessedAt'] != null
            ? DateTime.parse(json['lastAccessedAt'] as String)
            : DateTime.now(),
        progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
        completedTasks: json['completedTasks'] as int? ?? 0,
        totalTasks: json['totalTasks'] as int? ?? 0,
        moduleProgress: (json['moduleProgress'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, ModuleProgress.fromJson(v as Map<String, dynamic>))) ??
            {},
        status: json['status'] != null
            ? RoadmapStatus.fromJson(json['status'] as String)
            : RoadmapStatus.notStarted,
        totalTimeSpentMinutes: json['totalTimeSpentMinutes'] as int? ?? 0,
        currentModuleId: json['currentModuleId'] as String?,
        currentStageId: json['currentStageId'] as String?,
      );
}
