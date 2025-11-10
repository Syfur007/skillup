import 'package:skillup/domain/entities/task.dart';
import 'package:skillup/domain/entities/stage_resource.dart';

class ModuleStage {
  final String id;
  final String moduleId;
  final String title;
  final String description;
  final int order;
  final List<Task> tasks;
  final List<dynamic> quizzes; // future
  final List<StageResource> resources;
  final int estimatedMinutes;
  final bool isOptional;

  ModuleStage({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.description,
    required this.order,
    this.tasks = const [],
    this.quizzes = const [],
    this.resources = const [],
    this.estimatedMinutes = 0,
    this.isOptional = false,
  });

  ModuleStage copyWith({
    String? id,
    String? moduleId,
    String? title,
    String? description,
    int? order,
    List<Task>? tasks,
    List<dynamic>? quizzes,
    List<StageResource>? resources,
    int? estimatedMinutes,
    bool? isOptional,
  }) {
    return ModuleStage(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      tasks: tasks ?? this.tasks,
      quizzes: quizzes ?? this.quizzes,
      resources: resources ?? this.resources,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isOptional: isOptional ?? this.isOptional,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'moduleId': moduleId,
        'title': title,
        'description': description,
        'order': order,
        'tasks': tasks.map((t) => t.toJson()).toList(),
        'quizzes': quizzes,
        'resources': resources.map((r) => r.toJson()).toList(),
        'estimatedMinutes': estimatedMinutes,
        'isOptional': isOptional,
      };

  factory ModuleStage.fromJson(Map<String, dynamic> json) => ModuleStage(
        id: json['id'] as String,
        moduleId: json['moduleId'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        order: json['order'] as int,
        tasks: (json['tasks'] as List<dynamic>?)
                ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        quizzes: (json['quizzes'] as List<dynamic>?) ?? [],
        resources: (json['resources'] as List<dynamic>?)
                ?.map((e) => StageResource.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        estimatedMinutes: json['estimatedMinutes'] as int? ?? 0,
        isOptional: json['isOptional'] as bool? ?? false,
      );
}
