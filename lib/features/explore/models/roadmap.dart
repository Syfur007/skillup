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
}
