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
    progress: (() {
      final raw = json['progress'];
      if (raw == null) return 0.0;
      if (raw is num) return raw.toDouble();
      if (raw is String) {
        final parsed = double.tryParse(raw);
        return parsed ?? 0.0;
      }
      return 0.0;
    })(),
    completedSteps: (() {
      final map = <String, bool>{};
      final rawMap = json['completedSteps'];
      if (rawMap is Map) {
        rawMap.forEach((k, v) {
          bool val;
          if (v is bool) {
            val = v;
          } else if (v is num) {
            val = v != 0;
          } else if (v is String) {
            val = v.toLowerCase() == 'true';
          } else {
            val = false;
          }
          map[k as String] = val;
        });
      }
      return map;
    })(),
  );
}
