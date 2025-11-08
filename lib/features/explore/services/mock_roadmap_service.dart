import '../models/roadmap.dart';

class MockRoadmapService {
  Future<List<Roadmap>> getRoadmaps() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      Roadmap(
        id: '1',
        title: 'Flutter Development',
        description: 'Master Flutter and Dart from basics to advanced concepts',
        category: 'Mobile',
        iconName: 'flutter',
        stages: [
          RoadmapStage(
            title: 'Basics',
            description: 'Flutter fundamentals',
            steps: [
              RoadmapStep(
                name: 'Dart Basics',
                description: 'Learn Dart programming language',
                estimatedTime: const Duration(hours: 4),
              ),
              RoadmapStep(
                name: 'Flutter Setup',
                description: 'Setup development environment',
                estimatedTime: const Duration(hours: 1),
              ),
            ],
          ),
          RoadmapStage(
            title: 'UI Components',
            description: 'Essential widgets and layouts',
            steps: [
              RoadmapStep(
                name: 'Basic Widgets',
                description: 'Core widgets in Flutter',
                estimatedTime: const Duration(hours: 3),
              ),
            ],
          ),
        ],
      ),
      Roadmap(
        id: '2',
        title: 'Frontend Web Development',
        description: 'Learn HTML, CSS, JavaScript and modern frameworks',
        category: 'Web',
        iconName: 'web',
        stages: [
          RoadmapStage(
            title: 'HTML & CSS',
            description: 'Web fundamentals',
            steps: [
              RoadmapStep(
                name: 'HTML Basics',
                description: 'Structure of web pages',
                estimatedTime: const Duration(hours: 2),
              ),
            ],
          ),
        ],
      ),
      // Add more mock roadmaps as needed
    ];
  }
}
