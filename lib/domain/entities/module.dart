import 'package:skillup/domain/entities/module_stage.dart';

class Module {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final List<String> skillIds;
  final List<ModuleStage> stages;
  final String difficulty; // keep as string to allow reuse of roadmap difficulty
  final int estimatedHours;
  final int totalStages;
  final int totalTasks;
  final List<String> prerequisites;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublished;
  final int usageCount;
  final List<String> tags;

  Module({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.skillIds = const [],
    this.stages = const [],
    this.difficulty = 'beginner',
    this.estimatedHours = 0,
    this.totalStages = 0,
    this.totalTasks = 0,
    this.prerequisites = const [],
    required this.createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isPublished = false,
    this.usageCount = 0,
    this.tags = const [],
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Module copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    List<String>? skillIds,
    List<ModuleStage>? stages,
    String? difficulty,
    int? estimatedHours,
    int? totalStages,
    int? totalTasks,
    List<String>? prerequisites,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublished,
    int? usageCount,
    List<String>? tags,
  }) {
    return Module(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      skillIds: skillIds ?? this.skillIds,
      stages: stages ?? this.stages,
      difficulty: difficulty ?? this.difficulty,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      totalStages: totalStages ?? this.totalStages,
      totalTasks: totalTasks ?? this.totalTasks,
      prerequisites: prerequisites ?? this.prerequisites,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublished: isPublished ?? this.isPublished,
      usageCount: usageCount ?? this.usageCount,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'skillIds': skillIds,
        'stages': stages.map((s) => s.toJson()).toList(),
        'difficulty': difficulty,
        'estimatedHours': estimatedHours,
        'totalStages': totalStages,
        'totalTasks': totalTasks,
        'prerequisites': prerequisites,
        'createdBy': createdBy,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isPublished': isPublished,
        'usageCount': usageCount,
        'tags': tags,
      };

  factory Module.fromJson(Map<String, dynamic> json) => Module(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        imageUrl: json['imageUrl'] as String?,
        skillIds: (json['skillIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
        stages: (json['stages'] as List<dynamic>?)
                ?.map((e) => ModuleStage.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        difficulty: json['difficulty'] as String? ?? 'beginner',
        estimatedHours: json['estimatedHours'] as int? ?? 0,
        totalStages: json['totalStages'] as int? ?? 0,
        totalTasks: json['totalTasks'] as int? ?? 0,
        prerequisites: (json['prerequisites'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
        createdBy: json['createdBy'] as String,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : DateTime.now(),
        isPublished: json['isPublished'] as bool? ?? false,
        usageCount: json['usageCount'] as int? ?? 0,
        tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      );
}
