enum RoadmapCategory {
  technology,
  business,
  design,
  marketing,
  dataScience,
  softSkills,
  language,
  other;

  String toJson() => name;
  static RoadmapCategory fromJson(String v) => RoadmapCategory.values.firstWhere(
        (e) => e.name == v,
        orElse: () => RoadmapCategory.other,
      );
}

enum RoadmapDifficulty {
  beginner,
  intermediate,
  advanced,
  expert;

  String toJson() => name;
  static RoadmapDifficulty fromJson(String v) => RoadmapDifficulty.values.firstWhere(
        (e) => e.name == v,
        orElse: () => RoadmapDifficulty.beginner,
      );
}

class Roadmap {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? iconUrl;
  final RoadmapCategory category;
  final List<String> moduleIds;
  final RoadmapDifficulty difficulty;
  final int estimatedHours;
  final int totalModules;
  final int totalStages;
  final int totalTasks;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublished;
  final int enrolledCount;
  final double averageRating;
  final List<String> tags;

  Roadmap({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.iconUrl,
    this.category = RoadmapCategory.other,
    this.moduleIds = const [],
    this.difficulty = RoadmapDifficulty.beginner,
    this.estimatedHours = 0,
    this.totalModules = 0,
    this.totalStages = 0,
    this.totalTasks = 0,
    required this.createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isPublished = false,
    this.enrolledCount = 0,
    this.averageRating = 0.0,
    this.tags = const [],
  }) : createdAt = createdAt ?? DateTime.now(), updatedAt = updatedAt ?? DateTime.now();

  Roadmap copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? iconUrl,
    RoadmapCategory? category,
    List<String>? moduleIds,
    RoadmapDifficulty? difficulty,
    int? estimatedHours,
    int? totalModules,
    int? totalStages,
    int? totalTasks,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublished,
    int? enrolledCount,
    double? averageRating,
    List<String>? tags,
  }) {
    return Roadmap(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      iconUrl: iconUrl ?? this.iconUrl,
      category: category ?? this.category,
      moduleIds: moduleIds ?? this.moduleIds,
      difficulty: difficulty ?? this.difficulty,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      totalModules: totalModules ?? this.totalModules,
      totalStages: totalStages ?? this.totalStages,
      totalTasks: totalTasks ?? this.totalTasks,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublished: isPublished ?? this.isPublished,
      enrolledCount: enrolledCount ?? this.enrolledCount,
      averageRating: averageRating ?? this.averageRating,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'iconUrl': iconUrl,
        'category': category.toJson(),
        'moduleIds': moduleIds,
        'difficulty': difficulty.toJson(),
        'estimatedHours': estimatedHours,
        'totalModules': totalModules,
        'totalStages': totalStages,
        'totalTasks': totalTasks,
        'createdBy': createdBy,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isPublished': isPublished,
        'enrolledCount': enrolledCount,
        'averageRating': averageRating,
        'tags': tags,
      };

  factory Roadmap.fromJson(Map<String, dynamic> json) => Roadmap(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        imageUrl: json['imageUrl'] as String?,
        iconUrl: json['iconUrl'] as String?,
        category: json['category'] != null
            ? RoadmapCategory.fromJson(json['category'] as String)
            : RoadmapCategory.other,
        moduleIds: (json['moduleIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
        difficulty: json['difficulty'] != null
            ? RoadmapDifficulty.fromJson(json['difficulty'] as String)
            : RoadmapDifficulty.beginner,
        estimatedHours: json['estimatedHours'] as int? ?? 0,
        totalModules: json['totalModules'] as int? ?? 0,
        totalStages: json['totalStages'] as int? ?? 0,
        totalTasks: json['totalTasks'] as int? ?? 0,
        createdBy: json['createdBy'] as String,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : DateTime.now(),
        isPublished: json['isPublished'] as bool? ?? false,
        enrolledCount: json['enrolledCount'] as int? ?? 0,
        averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
        tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      );
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
      steps: (json['steps'] as List<dynamic>?)
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
