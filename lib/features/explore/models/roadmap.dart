class Roadmap {
  final String id;
  final String title;
  final String description;
  final String category;
  final String iconName;
  final List<RoadmapStage> stages;

  Roadmap({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.iconName,
    required this.stages,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'iconName': iconName,
      'stages': stages.map((s) => s.toJson()).toList(),
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
