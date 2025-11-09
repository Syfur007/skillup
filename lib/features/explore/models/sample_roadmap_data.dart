import 'roadmap.dart';

/// Sample roadmap data for testing and demonstration
class SampleRoadmapData {
  static Roadmap getSampleRoadmap() {
    return Roadmap(
      id: 'roadmap_flutter_basics',
      title: 'Flutter Development Fundamentals',
      description:
          'Master the fundamentals of Flutter development. Learn to build beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.',
      category: 'technology',
      iconName: 'flutter',
      imageUrl:
          'https://via.placeholder.com/400x200/2196F3/FFFFFF?text=Flutter+Basics',
      difficulty: 'beginner',
      estimatedHours: 40,
      totalModules: 4,
      totalStages: 12,
      totalTasks: 48,
      createdBy: 'Flutter Team',
      averageRating: 4.8,
      enrolledCount: 15234,
      tags: ['dart', 'mobile', 'ui', 'cross-platform'],
      moduleIds: ['module_1', 'module_2', 'module_3', 'module_4'],
      stages: [
        RoadmapStage(
          title: 'Dart Basics',
          description: 'Introduction to Dart programming language',
          steps: [
            RoadmapStep(
              name: 'Variables and Data Types',
              description:
                  'Learn about Dart variables, constants, and basic data types',
              estimatedTime: const Duration(minutes: 45),
            ),
            RoadmapStep(
              name: 'Control Flow',
              description: 'Master if/else, loops, and switch statements',
              estimatedTime: const Duration(minutes: 60),
            ),
            RoadmapStep(
              name: 'Functions',
              description: 'Understand functions, parameters, and return types',
              estimatedTime: const Duration(minutes: 75),
            ),
          ],
        ),
        RoadmapStage(
          title: 'Flutter Widgets',
          description: 'Understanding Flutter widgets and widget composition',
          steps: [
            RoadmapStep(
              name: 'Stateless Widgets',
              description: 'Build immutable UI components',
              estimatedTime: const Duration(minutes: 60),
            ),
            RoadmapStep(
              name: 'Stateful Widgets',
              description:
                  'Create interactive components with state management',
              estimatedTime: const Duration(minutes: 75),
            ),
            RoadmapStep(
              name: 'Widget Lifecycle',
              description: 'Understand widget lifecycle and state management',
              estimatedTime: const Duration(minutes: 90),
            ),
          ],
        ),
        RoadmapStage(
          title: 'Layouts & Navigation',
          description: 'Build responsive layouts and implement navigation',
          steps: [
            RoadmapStep(
              name: 'Common Layouts',
              description: 'Column, Row, Stack, and other layout widgets',
              estimatedTime: const Duration(minutes: 90),
            ),
            RoadmapStep(
              name: 'Navigation & Routing',
              description: 'Implement screen navigation and route management',
              estimatedTime: const Duration(minutes: 75),
            ),
          ],
        ),
      ],
    );
  }

  static Roadmap getSampleAdvancedRoadmap() {
    return Roadmap(
      id: 'roadmap_flutter_advanced',
      title: 'Advanced Flutter & State Management',
      description:
          'Take your Flutter skills to the next level. Explore advanced state management patterns, performance optimization, and complex UI implementations.',
      category: 'technology',
      iconName: 'flutter',
      imageUrl:
          'https://via.placeholder.com/400x200/1976D2/FFFFFF?text=Advanced+Flutter',
      difficulty: 'advanced',
      estimatedHours: 60,
      totalModules: 5,
      totalStages: 18,
      totalTasks: 72,
      createdBy: 'Flutter Experts',
      averageRating: 4.9,
      enrolledCount: 8921,
      tags: ['dart', 'state-management', 'architecture', 'performance'],
      moduleIds: ['module_adv_1', 'module_adv_2', 'module_adv_3', 'module_adv_4', 'module_adv_5'],
      stages: [
        RoadmapStage(
          title: 'State Management Patterns',
          description: 'Explore different state management approaches',
          steps: [
            RoadmapStep(
              name: 'Provider Pattern',
              description: 'Learn the Provider package for state management',
              estimatedTime: const Duration(minutes: 120),
            ),
            RoadmapStep(
              name: 'BLoC Pattern',
              description:
                  'Implement Business Logic Component pattern for scalability',
              estimatedTime: const Duration(minutes: 150),
            ),
            RoadmapStep(
              name: 'Riverpod',
              description: 'Modern reactive state management with Riverpod',
              estimatedTime: const Duration(minutes: 120),
            ),
          ],
        ),
        RoadmapStage(
          title: 'Performance Optimization',
          description: 'Optimize app performance and reduce build times',
          steps: [
            RoadmapStep(
              name: 'Profiling Tools',
              description: 'Use DevTools for performance profiling',
              estimatedTime: const Duration(minutes: 90),
            ),
            RoadmapStep(
              name: 'Lazy Loading & Caching',
              description:
                  'Implement efficient data loading and caching strategies',
              estimatedTime: const Duration(minutes: 105),
            ),
          ],
        ),
      ],
    );
  }

  static List<Roadmap> getSampleRoadmapList() {
    return [
      getSampleRoadmap(),
      getSampleAdvancedRoadmap(),
      Roadmap(
        id: 'roadmap_web_dev',
        title: 'Full Stack Web Development',
        description:
            'Learn to build complete web applications with modern tools and frameworks.',
        category: 'technology',
        iconName: 'web',
        difficulty: 'intermediate',
        estimatedHours: 80,
        totalModules: 6,
        totalStages: 20,
        totalTasks: 85,
        createdBy: 'Web Masters',
        averageRating: 4.7,
        enrolledCount: 22145,
        tags: ['web', 'frontend', 'backend', 'javascript'],
        moduleIds: ['web_1', 'web_2', 'web_3', 'web_4', 'web_5', 'web_6'],
        stages: [],
      ),
      Roadmap(
        id: 'roadmap_data_science',
        title: 'Data Science Fundamentals',
        description: 'Start your journey into data science and machine learning.',
        category: 'dataScience',
        iconName: 'data',
        difficulty: 'intermediate',
        estimatedHours: 70,
        totalModules: 5,
        totalStages: 15,
        totalTasks: 60,
        createdBy: 'Data Experts',
        averageRating: 4.6,
        enrolledCount: 18903,
        tags: ['python', 'ml', 'data-analysis', 'statistics'],
        moduleIds: ['ds_1', 'ds_2', 'ds_3', 'ds_4', 'ds_5'],
        stages: [],
      ),
    ];
  }
}

