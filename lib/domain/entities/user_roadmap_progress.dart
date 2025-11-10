// filepath: /home/syfur/Android/Flutter/skillup/lib/domain/entities/user_roadmap_progress.dart

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

