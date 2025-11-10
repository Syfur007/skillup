import 'package:skillup/domain/entities/roadmap.dart';
import 'package:skillup/domain/entities/module.dart';
import 'package:skillup/domain/entities/module_stage.dart';
import 'package:skillup/domain/entities/task.dart';

/// Sample roadmap data for testing and demonstration (domain entities)
class SampleRoadmapData {
  static Roadmap getSampleRoadmap() {
    return Roadmap(
      id: 'roadmap_flutter_basics',
      title: 'Flutter Development Fundamentals',
      description:
          'Master the fundamentals of Flutter development. Learn to build beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.',
      imageUrl: 'https://via.placeholder.com/400x200/2196F3/FFFFFF?text=Flutter+Basics',
      iconUrl: null,
      category: RoadmapCategory.technology,
      moduleIds: ['module_1', 'module_2', 'module_3', 'module_4'],
      difficulty: RoadmapDifficulty.beginner,
      estimatedHours: 40,
      totalModules: 4,
      totalStages: 12,
      totalTasks: 48,
      createdBy: 'Flutter Team',
      averageRating: 4.8,
      enrolledCount: 15234,
      tags: ['dart', 'mobile', 'ui', 'cross-platform'],
    );
  }

  static Roadmap getSampleAdvancedRoadmap() {
    return Roadmap(
      id: 'roadmap_flutter_advanced',
      title: 'Advanced Flutter & State Management',
      description:
          'Take your Flutter skills to the next level. Explore advanced state management patterns, performance optimization, and complex UI implementations.',
      imageUrl: 'https://via.placeholder.com/400x200/1976D2/FFFFFF?text=Advanced+Flutter',
      iconUrl: null,
      category: RoadmapCategory.technology,
      moduleIds: ['module_adv_1', 'module_adv_2', 'module_adv_3', 'module_adv_4', 'module_adv_5'],
      difficulty: RoadmapDifficulty.advanced,
      estimatedHours: 60,
      totalModules: 5,
      totalStages: 18,
      totalTasks: 72,
      createdBy: 'Flutter Experts',
      averageRating: 4.9,
      enrolledCount: 8921,
      tags: ['dart', 'state-management', 'architecture', 'performance'],
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
        imageUrl: null,
        iconUrl: null,
        category: RoadmapCategory.technology,
        moduleIds: ['web_1', 'web_2', 'web_3', 'web_4', 'web_5', 'web_6'],
        difficulty: RoadmapDifficulty.intermediate,
        estimatedHours: 80,
        totalModules: 6,
        totalStages: 20,
        totalTasks: 85,
        createdBy: 'Web Masters',
        averageRating: 4.7,
        enrolledCount: 22145,
        tags: ['web', 'frontend', 'backend', 'javascript'],
      ),
      Roadmap(
        id: 'roadmap_data_science',
        title: 'Data Science Fundamentals',
        description: 'Start your journey into data science and machine learning.',
        imageUrl: null,
        iconUrl: null,
        category: RoadmapCategory.dataScience,
        moduleIds: ['ds_1', 'ds_2', 'ds_3', 'ds_4', 'ds_5'],
        difficulty: RoadmapDifficulty.intermediate,
        estimatedHours: 70,
        totalModules: 5,
        totalStages: 15,
        totalTasks: 60,
        createdBy: 'Data Experts',
        averageRating: 4.6,
        enrolledCount: 18903,
        tags: ['python', 'ml', 'data-analysis', 'statistics'],
      ),
    ];
  }

  // -------------------- Sample Modules / Stages / Tasks --------------------

  /// Return a list of sample `Module` objects used by the sample roadmaps.
  static List<Module> getSampleModulesList() {
    return [
      // Module 1 - Dart Basics
      Module(
        id: 'module_1',
        title: 'Dart Basics',
        description: 'Fundamentals of the Dart programming language.',
        imageUrl: null,
        skillIds: const [],
        stages: [
          ModuleStage(
            id: 'module_1_stage_1',
            moduleId: 'module_1',
            title: 'Dart Syntax & Types',
            description: 'Variables, types, and basic syntax.',
            order: 1,
            tasks: [
              Task(
                id: 'task_m1_s1_t1',
                stageId: 'module_1_stage_1',
                title: 'Variables & Types',
                description: 'Learn Dart variables, final/const, and types.',
                order: 1,
                estimatedMinutes: 45,
                taskType: 'reading',
                points: 10,
              ),
              Task(
                id: 'task_m1_s1_t2',
                stageId: 'module_1_stage_1',
                title: 'Control Flow',
                description: 'if/else, loops and switch.',
                order: 2,
                estimatedMinutes: 60,
                taskType: 'practice',
                points: 15,
              ),
            ],
            estimatedMinutes: 105,
            isOptional: false,
          ),
          ModuleStage(
            id: 'module_1_stage_2',
            moduleId: 'module_1',
            title: 'Functions & Collections',
            description: 'Functions, lists, maps and higher-order functions.',
            order: 2,
            tasks: [
              Task(
                id: 'task_m1_s2_t1',
                stageId: 'module_1_stage_2',
                title: 'Functions',
                description: 'Defining and using functions.',
                order: 1,
                estimatedMinutes: 60,
                taskType: 'reading',
                points: 10,
              ),
            ],
            estimatedMinutes: 60,
          ),
        ],
        difficulty: 'beginner',
        estimatedHours: 6,
        totalStages: 2,
        totalTasks: 3,
        prerequisites: const [],
        createdBy: 'Flutter Team',
        tags: ['dart'],
      ),

      // Module 2 - Flutter Widgets
      Module(
        id: 'module_2',
        title: 'Flutter Widgets',
        description: 'Introduction to Flutter widgets and composition.',
        imageUrl: null,
        stages: [
          ModuleStage(
            id: 'module_2_stage_1',
            moduleId: 'module_2',
            title: 'Stateless vs Stateful',
            description: 'Widget types and when to use them.',
            order: 1,
            tasks: [
              Task(
                id: 'task_m2_s1_t1',
                stageId: 'module_2_stage_1',
                title: 'Stateless Widgets',
                description: 'Build immutable UI components.',
                order: 1,
                estimatedMinutes: 50,
                taskType: 'watching',
                points: 8,
              ),
            ],
            estimatedMinutes: 50,
          ),
          ModuleStage(
            id: 'module_2_stage_2',
            moduleId: 'module_2',
            title: 'State Management Basics',
            description: 'setState, lifting state, and simple patterns.',
            order: 2,
            tasks: [
              Task(
                id: 'task_m2_s2_t1',
                stageId: 'module_2_stage_2',
                title: 'setState & Lifecycle',
                description: 'Managing state with setState and widget lifecycle.',
                order: 1,
                estimatedMinutes: 70,
                taskType: 'practice',
                points: 12,
              ),
            ],
            estimatedMinutes: 70,
          ),
        ],
        difficulty: 'beginner',
        estimatedHours: 8,
        totalStages: 2,
        totalTasks: 2,
        prerequisites: const ['module_1'],
        createdBy: 'Flutter Team',
        tags: ['widgets', 'ui'],
      ),

      // Module 3 - Layouts & Navigation (placeholder)
      Module(
        id: 'module_3',
        title: 'Layouts & Navigation',
        description: 'Build responsive layouts and implement navigation.',
        imageUrl: null,
        stages: [
          ModuleStage(
            id: 'module_3_stage_1',
            moduleId: 'module_3',
            title: 'Common Layouts',
            description: 'Column, Row, Stack and more.',
            order: 1,
            tasks: [
              Task(
                id: 'task_m3_s1_t1',
                stageId: 'module_3_stage_1',
                title: 'Common Layouts',
                description: 'Learn columns, rows and stacks in Flutter.',
                order: 1,
                estimatedMinutes: 90,
                taskType: 'reading',
                points: 10,
              ),
            ],
            estimatedMinutes: 90,
          ),
        ],
        difficulty: 'beginner',
        estimatedHours: 6,
        totalStages: 1,
        totalTasks: 1,
        prerequisites: const ['module_1', 'module_2'],
        createdBy: 'Flutter Team',
        tags: ['layout', 'navigation'],
      ),

      // Module 4 - Practical Project
      Module(
        id: 'module_4',
        title: 'Mini Project: ToDo App',
        description: 'Build a small ToDo app to apply learned concepts.',
        imageUrl: null,
        stages: [
          ModuleStage(
            id: 'module_4_stage_1',
            moduleId: 'module_4',
            title: 'Project Setup & UI',
            description: 'Scaffold project and build UI.',
            order: 1,
            tasks: [
              Task(
                id: 'task_m4_s1_t1',
                stageId: 'module_4_stage_1',
                title: 'Project Setup',
                description: 'Initialize project and configure basic routing.',
                order: 1,
                estimatedMinutes: 60,
                taskType: 'practice',
                points: 20,
              ),
            ],
            estimatedMinutes: 60,
          ),
        ],
        difficulty: 'beginner',
        estimatedHours: 8,
        totalStages: 1,
        totalTasks: 1,
        prerequisites: const ['module_1', 'module_2', 'module_3'],
        createdBy: 'Flutter Team',
        tags: ['project', 'practice'],
      ),

      // A couple of advanced modules used by the advanced roadmap
      Module(
        id: 'module_adv_1',
        title: 'Advanced State Management',
        description: 'Provider, Riverpod and BLoC patterns.',
        createdBy: 'Flutter Experts',
        stages: [
          ModuleStage(
            id: 'module_adv_1_stage_1',
            moduleId: 'module_adv_1',
            title: 'Provider & InheritedWidget',
            description: 'Understand Provider fundamentals.',
            order: 1,
            tasks: [
              Task(
                id: 'task_adv1_s1_t1',
                stageId: 'module_adv_1_stage_1',
                title: 'Provider Basics',
                description: 'Using Provider for simple state management.',
                order: 1,
                estimatedMinutes: 90,
                taskType: 'reading',
                points: 15,
              ),
            ],
            estimatedMinutes: 90,
          ),
        ],
        difficulty: 'advanced',
        estimatedHours: 12,
        totalStages: 1,
        totalTasks: 1,
        prerequisites: const ['module_4'],
        tags: ['state-management'],
      ),

      Module(
        id: 'module_adv_2',
        title: 'Performance & Optimization',
        description: 'Optimize Flutter apps for speed and size.',
        createdBy: 'Flutter Experts',
        stages: [
          ModuleStage(
            id: 'module_adv_2_stage_1',
            moduleId: 'module_adv_2',
            title: 'Profiling & DevTools',
            description: 'Use DevTools to profile and optimize.',
            order: 1,
            tasks: [
              Task(
                id: 'task_adv2_s1_t1',
                stageId: 'module_adv_2_stage_1',
                title: 'Using DevTools',
                description: 'Profile and identify bottlenecks.',
                order: 1,
                estimatedMinutes: 80,
                taskType: 'reading',
                points: 10,
              ),
            ],
            estimatedMinutes: 80,
          ),
        ],
        difficulty: 'advanced',
        estimatedHours: 10,
        totalStages: 1,
        totalTasks: 1,
        prerequisites: const ['module_adv_1'],
        tags: ['performance'],
      ),
    ];
  }

  /// Convenience helper to lookup a sample module by id.
  static Module? getSampleModuleById(String id) {
    final modules = getSampleModulesList();
    for (final m in modules) {
      if (m.id == id) return m;
    }
    return null;
  }
}
