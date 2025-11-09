class Roadmap {
  final String id;
  final String title;
  final String description;
  final String category;
  final String iconName;
  final List<RoadmapStage> stages;
  final String? imageUrl;
  final String difficulty; // beginner, intermediate, advanced, expert
  final int estimatedHours;
  final int totalModules;
  final int totalStages;
  final int totalTasks;
  final String createdBy;
  final double averageRating;
  final int enrolledCount;
  final List<String> tags;
  final List<String> moduleIds;

  Roadmap({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.iconName,
    required this.stages,
    this.imageUrl,
    this.difficulty = 'beginner',
    this.estimatedHours = 0,
    this.totalModules = 0,
    this.totalStages = 0,
    this.totalTasks = 0,
    this.createdBy = 'Unknown',
    this.averageRating = 0.0,
    this.enrolledCount = 0,
    this.tags = const [],
    this.moduleIds = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'iconName': iconName,
      'stages': stages.map((s) => s.toJson()).toList(),
      'imageUrl': imageUrl,
      'difficulty': difficulty,
      'estimatedHours': estimatedHours,
      'totalModules': totalModules,
      'totalStages': totalStages,
      'totalTasks': totalTasks,
      'createdBy': createdBy,
      'averageRating': averageRating,
      'enrolledCount': enrolledCount,
      'tags': tags,
      'moduleIds': moduleIds,
    };
  }

  factory Roadmap.fromJson(String id, Map<String, dynamic> json) {
    return Roadmap(
      id: id,
      title: json['title'] as String? ?? 'Untitled',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      iconName: json['iconName'] as String? ?? '',
      stages:
          (json['stages'] as List<dynamic>?)
              ?.map((s) => RoadmapStage.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      imageUrl: json['imageUrl'] as String?,
      difficulty: json['difficulty'] as String? ?? 'beginner',
      estimatedHours: json['estimatedHours'] as int? ?? 0,
      totalModules: json['totalModules'] as int? ?? 0,
      totalStages: json['totalStages'] as int? ?? 0,
      totalTasks: json['totalTasks'] as int? ?? 0,
      createdBy: json['createdBy'] as String? ?? 'Unknown',
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      enrolledCount: json['enrolledCount'] as int? ?? 0,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      moduleIds: (json['moduleIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }
}

class RoadmapStage {
  final String title;
  final String description;
  final List<RoadmapStep> steps;

  RoadmapStage({
    required this.title,
    required this.description,
    required this.steps,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'steps': steps.map((s) => s.toJson()).toList(),
    };
  }

  factory RoadmapStage.fromJson(Map<String, dynamic> json) {
    return RoadmapStage(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((s) => RoadmapStep.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class RoadmapStep {
  final String name;
  final String description;
  final Duration estimatedTime;

  RoadmapStep({
    required this.name,
    required this.description,
    required this.estimatedTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'estimatedTimeMinutes': estimatedTime.inMinutes,
    };
  }

  factory RoadmapStep.fromJson(Map<String, dynamic> json) {
    return RoadmapStep(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      estimatedTime: Duration(
        minutes: json['estimatedTimeMinutes'] as int? ?? 0,
      ),
    );
  }
}
