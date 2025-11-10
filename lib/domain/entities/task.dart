enum TaskType { reading, watching, practice, project, research, discussion, other;
  String toJson() => name;
  static TaskType fromJson(String v) => TaskType.values.firstWhere((e) => e.name == v, orElse: () => TaskType.other);
}

class Task {
  final String id;
  final String stageId;
  final String title;
  final String description;
  final int order;
  final int estimatedMinutes;
  final List<dynamic> resources; // LearningResource items; keep dynamic to avoid circular import
  final String taskType;
  final bool isOptional;
  final int points;

  Task({
    required this.id,
    required this.stageId,
    required this.title,
    required this.description,
    required this.order,
    this.estimatedMinutes = 0,
    this.resources = const [],
    this.taskType = 'other',
    this.isOptional = false,
    this.points = 0,
  });

  Task copyWith({
    String? id,
    String? stageId,
    String? title,
    String? description,
    int? order,
    int? estimatedMinutes,
    List<dynamic>? resources,
    String? taskType,
    bool? isOptional,
    int? points,
  }) {
    return Task(
      id: id ?? this.id,
      stageId: stageId ?? this.stageId,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      resources: resources ?? this.resources,
      taskType: taskType ?? this.taskType,
      isOptional: isOptional ?? this.isOptional,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'stageId': stageId,
        'title': title,
        'description': description,
        'order': order,
        'estimatedMinutes': estimatedMinutes,
        'resources': resources,
        'taskType': taskType,
        'isOptional': isOptional,
        'points': points,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        stageId: json['stageId'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        order: json['order'] as int,
        estimatedMinutes: json['estimatedMinutes'] as int? ?? 0,
        resources: (json['resources'] as List<dynamic>?) ?? [],
        taskType: (json['taskType'] as String?) ?? 'other',
        isOptional: json['isOptional'] as bool? ?? false,
        points: json['points'] as int? ?? 0,
      );
}
