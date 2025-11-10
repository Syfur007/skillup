class UserRoadmap {
  final String roadmapId;
  final DateTime startedAt;
  final double progress;
  final Map<String, bool> completedSteps;

  UserRoadmap({
    required this.roadmapId,
    required this.startedAt,
    this.progress = 0.0,
    Map<String, bool>? completedSteps,
  }) : completedSteps = completedSteps ?? {};

  Map<String, dynamic> toJson() => {
    'roadmapId': roadmapId,
    'startedAt': startedAt.toIso8601String(),
    'progress': progress,
    'completedSteps': completedSteps,
  };

  factory UserRoadmap.fromJson(Map<String, dynamic> json) => UserRoadmap(
    roadmapId: json['roadmapId'],
    startedAt: DateTime.parse(json['startedAt']),
    progress: json['progress'] ?? 0.0,
    completedSteps: Map<String, bool>.from(json['completedSteps'] ?? {}),
  );
}
