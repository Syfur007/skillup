import 'package:skillup/domain/entities/roadmap.dart';
import 'package:skillup/domain/entities/module.dart';
import 'package:skillup/domain/entities/module_stage.dart';
import 'package:skillup/domain/entities/task.dart';
import 'package:skillup/domain/entities/stage_resource.dart';

/// Cleaned sample roadmap data for testing and demonstration
class SampleRoadmapData {
  // --- ROADMAPS -----------------------------------------------------------------
  static Roadmap getFlutterBasics() => Roadmap(
        id: 'roadmap_flutter_basics',
        title: 'Flutter Development Fundamentals',
        description:
            'Learn Flutter basics: Dart, widgets, layouts, navigation and a mini project to apply your skills.',
        imageUrl:
            'https://via.placeholder.com/400x200/2196F3/FFFFFF?text=Flutter+Basics',
        iconUrl: null,
        category: RoadmapCategory.technology,
        moduleIds: ['m_dart_basics', 'm_widgets', 'm_layouts', 'm_project'],
        difficulty: RoadmapDifficulty.beginner,
        estimatedHours: 40,
        totalModules: 4,
        totalStages: 8,
        totalTasks: 18,
        createdBy: 'Flutter Team',
        averageRating: 4.8,
        enrolledCount: 15234,
        tags: ['dart', 'mobile', 'ui'],
      );

  static Roadmap getFlutterAdvanced() => Roadmap(
        id: 'roadmap_flutter_advanced',
        title: 'Advanced Flutter & State Management',
        description:
            'Advanced patterns: state management, performance, architecture and testing.',
        imageUrl:
            'https://via.placeholder.com/400x200/1976D2/FFFFFF?text=Advanced+Flutter',
        iconUrl: null,
        category: RoadmapCategory.technology,
        moduleIds: ['m_state', 'm_performance', 'm_architecture', 'm_testing'],
        difficulty: RoadmapDifficulty.advanced,
        estimatedHours: 60,
        totalModules: 4,
        totalStages: 8,
        totalTasks: 16,
        createdBy: 'Flutter Experts',
        averageRating: 4.9,
        enrolledCount: 8921,
        tags: ['state-management', 'performance'],
      );

  static Roadmap getWebFullstack() => Roadmap(
        id: 'roadmap_web_fullstack',
        title: 'Full Stack Web Development',
        description:
            'Frontend, backend and deployment: HTML/CSS/JS, React, Node.js and databases.',
        imageUrl: null,
        iconUrl: null,
        category: RoadmapCategory.technology,
        moduleIds: ['m_html_css', 'm_js', 'm_react', 'm_node'],
        difficulty: RoadmapDifficulty.intermediate,
        estimatedHours: 80,
        totalModules: 4,
        totalStages: 10,
        totalTasks: 24,
        createdBy: 'Web Masters',
        averageRating: 4.7,
        enrolledCount: 22145,
        tags: ['web', 'javascript', 'backend'],
      );

  static Roadmap getDataScience() => Roadmap(
        id: 'roadmap_data_science',
        title: 'Data Science Fundamentals',
        description: 'Statistics, Python, data analysis and basic machine learning.',
        imageUrl: null,
        iconUrl: null,
        category: RoadmapCategory.dataScience,
        moduleIds: ['m_python', 'm_pandas', 'm_ml'],
        difficulty: RoadmapDifficulty.intermediate,
        estimatedHours: 70,
        totalModules: 3,
        totalStages: 7,
        totalTasks: 18,
        createdBy: 'Data Experts',
        averageRating: 4.6,
        enrolledCount: 18903,
        tags: ['python', 'ml', 'data-analysis'],
      );

  static Roadmap getDesignAndMobile() => Roadmap(
        id: 'roadmap_design_mobile',
        title: 'Mobile UX & App Patterns',
        description:
            'Design fundamentals and common mobile app architecture patterns.',
        imageUrl: null,
        iconUrl: null,
        category: RoadmapCategory.design,
        moduleIds: ['m_uiux', 'm_patterns', 'm_accessibility'],
        difficulty: RoadmapDifficulty.beginner,
        estimatedHours: 30,
        totalModules: 3,
        totalStages: 6,
        totalTasks: 12,
        createdBy: 'Design Team',
        averageRating: 4.5,
        enrolledCount: 7120,
        tags: ['design', 'ux', 'mobile'],
      );

  static List<Roadmap> getSampleRoadmapList() {
    return [
      getFlutterBasics(),
      getFlutterAdvanced(),
      getWebFullstack(),
      getDataScience(),
      getDesignAndMobile(),
    ];
  }

  // --- MODULES -----------------------------------------------------------------
  /// Return a list of sample `Module` objects used by the sample roadmaps.
  static List<Module> getSampleModulesList() {
    return [
      // Flutter Basics Modules
      Module(
        id: 'm_dart_basics',
        title: 'Dart Basics',
        description: 'Fundamentals of the Dart programming language.',
        stages: [
          ModuleStage(
            id: 'm_dart_syntax',
            moduleId: 'm_dart_basics',
            title: 'Syntax & Types',
            description: 'Variables, types, and basic syntax.',
            order: 1,
            estimatedMinutes: 90,
            tasks: [
              Task(id: 't_dart_1', stageId: 'm_dart_syntax', title: 'Variables & Types', description: 'Learn Dart variables, final/const.', order: 1, estimatedMinutes: 30, taskType: 'reading', points: 5),
              Task(id: 't_dart_2', stageId: 'm_dart_syntax', title: 'Control Flow', description: 'if/else, loops and switch.', order: 2, estimatedMinutes: 60, taskType: 'practice', points: 10),
            ],
            resources: [
              StageResource(id: 'r_dart_1', stageId: 'm_dart_syntax', title: 'Dart Guide', description: 'Official Dart language guide', url: 'https://dart.dev/guides', type: 'documentation', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_dart_collections',
            moduleId: 'm_dart_basics',
            title: 'Functions & Collections',
            description: 'Functions, lists, maps and higher-order functions.',
            order: 2,
            estimatedMinutes: 60,
            tasks: [
              Task(id: 't_dart_3', stageId: 'm_dart_collections', title: 'Functions', description: 'Defining and using functions.', order: 1, estimatedMinutes: 60, taskType: 'reading', points: 5),
            ],
            resources: [
              StageResource(id: 'r_dart_2', stageId: 'm_dart_collections', title: 'Dart Codelabs', description: 'Interactive Dart learning exercises', url: 'https://dart.dev/codelabs', type: 'interactive', isRequired: true),
            ],
          ),
        ],
        difficulty: 'beginner',
        estimatedHours: 3,
        totalStages: 2,
        totalTasks: 3,
        tags: ['dart'],
        createdBy: 'Flutter Team',
      ),

      Module(
        id: 'm_widgets',
        title: 'Flutter Widgets',
        description: 'Introduction to Flutter widgets and composition.',
        stages: [
          ModuleStage(
            id: 'm_widgets_stateless',
            moduleId: 'm_widgets',
            title: 'Stateless vs Stateful',
            description: 'Widget types and when to use them.',
            order: 1,
            estimatedMinutes: 50,
            tasks: [
              Task(id: 't_w_1', stageId: 'm_widgets_stateless', title: 'Stateless Widgets', description: 'Immutable UI components.', order: 1, estimatedMinutes: 50, taskType: 'reading', points: 5),
            ],
            resources: [
              StageResource(id: 'r_w_1', stageId: 'm_widgets_stateless', title: 'Flutter Widgets', description: 'Complete widget documentation', url: 'https://flutter.dev/docs/development/ui/widgets', type: 'documentation', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_widgets_state',
            moduleId: 'm_widgets',
            title: 'State Management Basics',
            description: 'setState, lifting state, and simple patterns.',
            order: 2,
            estimatedMinutes: 70,
            tasks: [
              Task(id: 't_w_2', stageId: 'm_widgets_state', title: 'setState & Lifecycle', description: 'Managing state with setState and lifecycle.', order: 1, estimatedMinutes: 70, taskType: 'practice', points: 8),
            ],
            resources: [
              StageResource(id: 'r_w_2', stageId: 'm_widgets_state', title: 'State Management Guide', description: 'Flutter state management patterns', url: 'https://flutter.dev/docs/development/data-and-backend/state-mgmt', type: 'documentation', isRequired: true),
            ],
          ),
        ],
        difficulty: 'beginner',
        estimatedHours: 4,
        totalStages: 2,
        totalTasks: 2,
        tags: ['widgets', 'ui'],
        createdBy: 'Flutter Team',
      ),

      Module(
        id: 'm_layouts',
        title: 'Layouts & Navigation',
        description: 'Build responsive layouts and implement navigation.',
        stages: [
          ModuleStage(
            id: 'm_layouts_common',
            moduleId: 'm_layouts',
            title: 'Common Layouts',
            description: 'Column, Row, Stack and more.',
            order: 1,
            estimatedMinutes: 90,
            tasks: [
              Task(id: 't_l_1', stageId: 'm_layouts_common', title: 'Common Layouts', description: 'Learn columns, rows and stacks.', order: 1, estimatedMinutes: 90, taskType: 'reading', points: 6),
            ],
            resources: [
              StageResource(id: 'r_l_1', stageId: 'm_layouts_common', title: 'Layout Guide', description: 'Comprehensive Flutter layout guide', url: 'https://flutter.dev/docs/development/ui/layout', type: 'documentation', isRequired: true),
            ],
          ),
        ],
        difficulty: 'beginner',
        estimatedHours: 3,
        totalStages: 1,
        totalTasks: 1,
        tags: ['layout', 'navigation'],
        createdBy: 'Flutter Team',
      ),

      Module(
        id: 'm_project',
        title: 'Mini Project: ToDo App',
        description: 'Build a small ToDo app to apply learned concepts.',
        stages: [
          ModuleStage(
            id: 'm_proj_setup',
            moduleId: 'm_project',
            title: 'Project Setup & UI',
            description: 'Scaffold project and build UI.',
            order: 1,
            estimatedMinutes: 60,
            tasks: [
              Task(id: 't_p_1', stageId: 'm_proj_setup', title: 'Project Setup', description: 'Initialize project and routing.', order: 1, estimatedMinutes: 60, taskType: 'practice', points: 12),
            ],
            resources: [
              StageResource(id: 'r_p_1', stageId: 'm_proj_setup', title: 'Flutter Codelab', description: 'Hands-on Flutter project tutorial', url: 'https://flutter.dev/docs/get-started/codelab', type: 'interactive', isRequired: true),
            ],
          ),
        ],
        difficulty: 'beginner',
        estimatedHours: 3,
        totalStages: 1,
        totalTasks: 1,
        tags: ['project', 'practice'],
        createdBy: 'Flutter Team',
      ),

      // Advanced Flutter Modules
      Module(
        id: 'm_state',
        title: 'Advanced State Management',
        description: 'Provider, Riverpod and Bloc patterns.',
        stages: [
          ModuleStage(
            id: 'm_state_provider',
            moduleId: 'm_state',
            title: 'Provider Basics',
            description: 'Using Provider for state management.',
            order: 1,
            estimatedMinutes: 90,
            tasks: [
              Task(id: 't_state_1', stageId: 'm_state_provider', title: 'Provider Setup', description: 'Integrate Provider into your app.', order: 1, estimatedMinutes: 45, taskType: 'practice', points: 10),
            ],
            resources: [
              StageResource(id: 'r_state_1', stageId: 'm_state_provider', title: 'Provider Package', description: 'Provider package documentation', url: 'https://pub.dev/packages/provider', type: 'documentation', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_state_riverpod',
            moduleId: 'm_state',
            title: 'Riverpod Introduction',
            description: 'Learn the basics of Riverpod for state management.',
            order: 2,
            estimatedMinutes: 60,
            tasks: [
              Task(id: 't_state_2', stageId: 'm_state_riverpod', title: 'Using Riverpod', description: 'Manage state with Riverpod.', order: 1, estimatedMinutes: 60, taskType: 'reading', points: 8),
            ],
            resources: [
              StageResource(id: 'r_state_2', stageId: 'm_state_riverpod', title: 'Riverpod Docs', description: 'Official Riverpod documentation', url: 'https://riverpod.dev/docs/getting_started', type: 'documentation', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_state_bloc',
            moduleId: 'm_state',
            title: 'Bloc Pattern',
            description: 'Implementing the Bloc pattern for state management.',
            order: 3,
            estimatedMinutes: 120,
            tasks: [
              Task(id: 't_state_3', stageId: 'm_state_bloc', title: 'Bloc Basics', description: 'Understand and implement the Bloc pattern.', order: 1, estimatedMinutes: 120, taskType: 'practice', points: 15),
            ],
            resources: [
              StageResource(id: 'r_state_3', stageId: 'm_state_bloc', title: 'Flutter Bloc', description: 'Flutter Bloc library and patterns', url: 'https://pub.dev/packages/flutter_bloc', type: 'documentation', isRequired: true),
            ],
          ),
        ],
        difficulty: 'advanced',
        estimatedHours: 12,
        totalStages: 3,
        totalTasks: 3,
        tags: ['state-management'],
        createdBy: 'Flutter Experts',
      ),

      Module(
        id: 'm_performance',
        title: 'Performance Optimization',
        description: 'Optimize Flutter apps for speed and efficiency.',
        stages: [
          ModuleStage(
            id: 'm_performance_profiling',
            moduleId: 'm_performance',
            title: 'Profiling Flutter Apps',
            description: 'Use Flutter DevTools to profile your app.',
            order: 1,
            estimatedMinutes: 90,
            tasks: [
              Task(id: 't_perf_1', stageId: 'm_performance_profiling', title: 'DevTools Overview', description: 'Get started with Flutter DevTools.', order: 1, estimatedMinutes: 45, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_perf_1', stageId: 'm_performance_profiling', title: 'Flutter DevTools', description: 'Flutter performance profiling tools', url: 'https://flutter.dev/docs/development/tools/devtools', type: 'documentation', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_performance_optimizing',
            moduleId: 'm_performance',
            title: 'Optimizing Performance',
            description: 'Techniques to optimize Flutter app performance.',
            order: 2,
            estimatedMinutes: 120,
            tasks: [
              Task(id: 't_perf_2', stageId: 'm_performance_optimizing', title: 'Performance Best Practices', description: 'Learn best practices for Flutter performance.', order: 1, estimatedMinutes: 120, taskType: 'reading', points: 15),
            ],
            resources: [
              StageResource(id: 'r_perf_2', stageId: 'm_performance_optimizing', title: 'Performance Guide', description: 'Comprehensive Flutter performance optimization', url: 'https://flutter.dev/docs/perf', type: 'documentation', isRequired: true),
            ],
          ),
        ],
        difficulty: 'advanced',
        estimatedHours: 10,
        totalStages: 2,
        totalTasks: 2,
        tags: ['performance'],
        createdBy: 'Flutter Experts',
      ),

      Module(
        id: 'm_architecture',
        title: 'App Architecture',
        description: 'Architecting Flutter apps: Clean Architecture, MVVM, and more.',
        stages: [
          ModuleStage(
            id: 'm_architecture_clean',
            moduleId: 'm_architecture',
            title: 'Clean Architecture',
            description: 'Implementing Clean Architecture in Flutter.',
            order: 1,
            estimatedMinutes: 120,
            tasks: [
              Task(id: 't_arch_1', stageId: 'm_architecture_clean', title: 'Clean Architecture Basics', description: 'Understand the principles of Clean Architecture.', order: 1, estimatedMinutes: 120, taskType: 'reading', points: 15),
            ],
            resources: [
              StageResource(id: 'r_arch_1', stageId: 'm_architecture_clean', title: 'Clean Flutter', description: 'Clean Architecture in Flutter guide', url: 'https://cleanflutter.com/', type: 'documentation', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_architecture_mvvm',
            moduleId: 'm_architecture',
            title: 'MVVM Pattern',
            description: 'Model-View-ViewModel pattern in Flutter.',
            order: 2,
            estimatedMinutes: 90,
            tasks: [
              Task(id: 't_arch_2', stageId: 'm_architecture_mvvm', title: 'Implementing MVVM', description: 'Build an app using the MVVM pattern.', order: 1, estimatedMinutes: 90, taskType: 'practice', points: 12),
            ],
            resources: [
              StageResource(id: 'r_arch_2', stageId: 'm_architecture_mvvm', title: 'MVVM Guide', description: 'MVVM pattern implementation in Flutter', url: 'https://flutter.dev/docs/development/ui/advanced/mvvm', type: 'documentation', isRequired: false),
            ],
          ),
        ],
        difficulty: 'advanced',
        estimatedHours: 8,
        totalStages: 2,
        totalTasks: 2,
        tags: ['architecture'],
        createdBy: 'Flutter Experts',
      ),

      Module(
        id: 'm_testing',
        title: 'Testing Flutter Apps',
        description: 'Unit testing, widget testing, and integration testing.',
        stages: [
          ModuleStage(
            id: 'm_testing_unit',
            moduleId: 'm_testing',
            title: 'Unit Testing',
            description: 'Write and run unit tests in Flutter.',
            order: 1,
            estimatedMinutes: 60,
            tasks: [
              Task(id: 't_test_1', stageId: 'm_testing_unit', title: 'Unit Testing Basics', description: 'Introduction to unit testing in Flutter.', order: 1, estimatedMinutes: 60, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_test_1', stageId: 'm_testing_unit', title: 'Unit Testing Cookbook', description: 'Flutter unit testing recipes', url: 'https://flutter.dev/docs/cookbook/testing/unit', type: 'documentation', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_testing_widget',
            moduleId: 'm_testing',
            title: 'Widget Testing',
            description: 'Testing Flutter widgets.',
            order: 2,
            estimatedMinutes: 90,
            tasks: [
              Task(id: 't_test_2', stageId: 'm_testing_widget', title: 'Widget Testing Basics', description: 'Introduction to widget testing in Flutter.', order: 1, estimatedMinutes: 90, taskType: 'reading', points: 12),
            ],
            resources: [
              StageResource(id: 'r_test_2', stageId: 'm_testing_widget', title: 'Widget Testing Cookbook', description: 'Flutter widget testing recipes', url: 'https://flutter.dev/docs/cookbook/testing/widget', type: 'documentation', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_testing_integration',
            moduleId: 'm_testing',
            title: 'Integration Testing',
            description: 'Testing complete apps or large parts of apps.',
            order: 3,
            estimatedMinutes: 120,
            tasks: [
              Task(id: 't_test_3', stageId: 'm_testing_integration', title: 'Integration Testing Basics', description: 'Introduction to integration testing in Flutter.', order: 1, estimatedMinutes: 120, taskType: 'reading', points: 15),
            ],
            resources: [
              StageResource(id: 'r_test_3', stageId: 'm_testing_integration', title: 'Integration Testing Cookbook', description: 'Flutter integration testing recipes', url: 'https://flutter.dev/docs/cookbook/testing/integration', type: 'documentation', isRequired: true),
            ],
          ),
        ],
        difficulty: 'advanced',
        estimatedHours: 10,
        totalStages: 3,
        totalTasks: 3,
        tags: ['testing'],
        createdBy: 'Flutter Experts',
      ),

      // Web Fullstack Modules
      Module(
        id: 'm_html_css',
        title: 'HTML & CSS Fundamentals',
        description: 'Learn the building blocks of web development.',
        stages: [
          ModuleStage(
            id: 'm_html_basics',
            moduleId: 'm_html_css',
            title: 'HTML Basics',
            description: 'Structure of web pages with HTML.',
            order: 1,
            estimatedMinutes: 60,
            tasks: [
              Task(id: 't_html_1', stageId: 'm_html_basics', title: 'HTML Introduction', description: 'What is HTML and how to use it.', order: 1, estimatedMinutes: 30, taskType: 'reading', points: 5),
            ],
            resources: [
              StageResource(id: 'r_html_1', stageId: 'm_html_basics', title: 'HTML Basics', description: 'MDN HTML basics guide', url: 'https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web/HTML_basics', type: 'documentation', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_css_basics',
            moduleId: 'm_html_css',
            title: 'CSS Basics',
            description: 'Styling web pages with CSS.',
            order: 2,
            estimatedMinutes: 60,
            tasks: [
              Task(id: 't_css_1', stageId: 'm_css_basics', title: 'CSS Introduction', description: 'What is CSS and how to use it.', order: 1, estimatedMinutes: 30, taskType: 'reading', points: 5),
            ],
            resources: [
              StageResource(id: 'r_css_1', stageId: 'm_css_basics', title: 'CSS Basics', description: 'MDN CSS basics guide', url: 'https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web/CSS_basics', type: 'documentation', isRequired: true),
            ],
          ),
        ],
        difficulty: 'beginner',
        estimatedHours: 4,
        totalStages: 2,
        totalTasks: 2,
        tags: ['html', 'css', 'web'],
        createdBy: 'Web Masters',
      ),

      Module(
        id: 'm_js',
        title: 'JavaScript Essentials',
        description: 'Master the language of the web.',
        stages: [
          ModuleStage(
            id: 'm_js_basics',
            moduleId: 'm_js',
            title: 'JavaScript Basics',
            description: 'Syntax, variables, and control structures.',
            order: 1,
            estimatedMinutes: 90,
            tasks: [
              Task(id: 't_js_1', stageId: 'm_js_basics', title: 'JavaScript Introduction', description: 'What is JavaScript and how to use it.', order: 1, estimatedMinutes: 45, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_js_1', stageId: 'm_js_basics', title: 'JS First Steps', description: 'MDN JavaScript first steps guide', url: 'https://developer.mozilla.org/en-US/docs/Learn/JavaScript/First_steps', type: 'documentation', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_js_advanced',
            moduleId: 'm_js',
            title: 'Advanced JavaScript',
            description: 'Functions, objects, and arrays.',
            order: 2,
            estimatedMinutes: 120,
            tasks: [
              Task(id: 't_js_2', stageId: 'm_js_advanced', title: 'JavaScript Functions', description: 'Learn about functions in JavaScript.', order: 1, estimatedMinutes: 60, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_js_2', stageId: 'm_js_advanced', title: 'JS Objects', description: 'MDN JavaScript objects guide', url: 'https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Objects', type: 'documentation', isRequired: true),
            ],
          ),
        ],
        difficulty: 'beginner',
        estimatedHours: 6,
        totalStages: 2,
        totalTasks: 2,
        tags: ['javascript', 'web', 'programming'],
        createdBy: 'Web Masters',
      ),

      Module(
        id: 'm_react',
        title: 'React Fundamentals',
        description: 'Build modern web apps with React.',
        stages: [
          ModuleStage(
            id: 'm_react_intro',
            moduleId: 'm_react',
            title: 'Introduction to React',
            description: 'Components, JSX, and props.',
            order: 1,
            estimatedMinutes: 90,
            tasks: [
              Task(id: 't_react_1', stageId: 'm_react_intro', title: 'React Components', description: 'Understand React components and JSX.', order: 1, estimatedMinutes: 45, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_react_1', stageId: 'm_react_intro', title: 'React Getting Started', description: 'Official React documentation', url: 'https://reactjs.org/docs/getting-started.html', type: 'documentation', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_react_state',
            moduleId: 'm_react',
            title: 'State and Lifecycle',
            description: 'Managing state and component lifecycle.',
            order: 2,
            estimatedMinutes: 120,
            tasks: [
              Task(id: 't_react_2', stageId: 'm_react_state', title: 'State in React', description: 'Learn how to manage state in React components.', order: 1, estimatedMinutes: 60, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_react_2', stageId: 'm_react_state', title: 'React State & Lifecycle', description: 'React state and lifecycle documentation', url: 'https://reactjs.org/docs/state-and-lifecycle.html', type: 'documentation', isRequired: true),
            ],
          ),
        ],
        difficulty: 'intermediate',
        estimatedHours: 8,
        totalStages: 2,
        totalTasks: 2,
        tags: ['react', 'javascript', 'frontend'],
        createdBy: 'Web Masters',
      ),

      Module(
        id: 'm_node',
        title: 'Node.js Backend Development',
        description: 'Build scalable backend services with Node.js.',
        stages: [
          ModuleStage(
            id: 'm_node_intro',
            moduleId: 'm_node',
            title: 'Introduction to Node.js',
            description: 'Node.js architecture, modules, and npm.',
            order: 1,
            estimatedMinutes: 90,
            tasks: [
              Task(id: 't_node_1', stageId: 'm_node_intro', title: 'Node.js Basics', description: 'Learn the basics of Node.js and npm.', order: 1, estimatedMinutes: 45, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_node_1', stageId: 'm_node_intro', title: 'Node.js Learn', description: 'Official Node.js learning resources', url: 'https://nodejs.dev/learn', type: 'documentation', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_node_express',
            moduleId: 'm_node',
            title: 'Building RESTful APIs with Express',
            description: 'Create APIs using Express.js and Node.js.',
            order: 2,
            estimatedMinutes: 120,
            tasks: [
              Task(id: 't_node_2', stageId: 'm_node_express', title: 'Express Basics', description: 'Learn how to create a server with Express.js.', order: 1, estimatedMinutes: 60, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_node_2', stageId: 'm_node_express', title: 'Express Installation', description: 'Express.js getting started guide', url: 'https://expressjs.com/en/starter/installing.html', type: 'documentation', isRequired: true),
            ],
          ),
        ],
        difficulty: 'intermediate',
        estimatedHours: 10,
        totalStages: 2,
        totalTasks: 2,
        tags: ['nodejs', 'backend', 'javascript'],
        createdBy: 'Backend Team',
      ),

      // Data Science Modules
      Module(
        id: 'm_python',
        title: 'Python for Data Science',
        description: 'Learn Python programming for data analysis.',
        stages: [
          ModuleStage(
            id: 'm_python_intro',
            moduleId: 'm_python',
            title: 'Introduction to Python',
            description: 'Python syntax, variables, and control structures.',
            order: 1,
            estimatedMinutes: 90,
            tasks: [
              Task(id: 't_py_1', stageId: 'm_python_intro', title: 'Python Basics', description: 'Learn the basics of Python programming.', order: 1, estimatedMinutes: 45, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_py_1', stageId: 'm_python_intro', title: 'Learn Python', description: 'Interactive Python learning platform', url: 'https://www.learnpython.org/', type: 'interactive', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_python_data',
            moduleId: 'm_python',
            title: 'Data Analysis with Python',
            description: 'Using Python for data analysis and visualization.',
            order: 2,
            estimatedMinutes: 120,
            tasks: [
              Task(id: 't_py_2', stageId: 'm_python_data', title: 'Pandas Basics', description: 'Learn data manipulation with Pandas.', order: 1, estimatedMinutes: 60, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_py_2', stageId: 'm_python_data', title: 'Pandas Tutorial', description: 'Pandas getting started tutorial', url: 'https://pandas.pydata.org/docs/getting_started/intro_tutorials/index.html', type: 'documentation', isRequired: true),
            ],
          ),
        ],
        difficulty: 'beginner',
        estimatedHours: 8,
        totalStages: 2,
        totalTasks: 2,
        tags: ['python', 'programming', 'data'],
        createdBy: 'Data Experts',
      ),

      Module(
        id: 'm_pandas',
        title: 'Data Analysis with Pandas',
        description: 'Master data manipulation and analysis.',
        stages: [
          ModuleStage(
            id: 'm_pandas_intro',
            moduleId: 'm_pandas',
            title: 'Pandas Basics',
            description: 'Introduction to data analysis with Pandas.',
            order: 1,
            estimatedMinutes: 90,
            tasks: [
              Task(id: 't_pandas_1', stageId: 'm_pandas_intro', title: 'Getting Started with Pandas', description: 'Learn how to use Pandas for data analysis.', order: 1, estimatedMinutes: 45, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_pandas_1', stageId: 'm_pandas_intro', title: 'Pandas Intro Tutorials', description: 'Pandas introductory tutorials', url: 'https://pandas.pydata.org/docs/getting_started/intro_tutorials/index.html', type: 'documentation', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_pandas_advanced',
            moduleId: 'm_pandas',
            title: 'Advanced Pandas',
            description: 'Advanced data manipulation techniques with Pandas.',
            order: 2,
            estimatedMinutes: 120,
            tasks: [
              Task(id: 't_pandas_2', stageId: 'm_pandas_advanced', title: 'Data Cleaning and Preparation', description: 'Learn advanced data cleaning techniques.', order: 1, estimatedMinutes: 60, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_pandas_2', stageId: 'm_pandas_advanced', title: 'Pandas 10 Min', description: '10 minute Pandas guide', url: 'https://pandas.pydata.org/pandas-docs/stable/user_guide/10min.html', type: 'documentation', isRequired: true),
            ],
          ),
        ],
        difficulty: 'intermediate',
        estimatedHours: 8,
        totalStages: 2,
        totalTasks: 2,
        tags: ['pandas', 'data-analysis', 'python'],
        createdBy: 'Data Experts',
      ),

      Module(
        id: 'm_ml',
        title: 'Machine Learning Basics',
        description: 'Introduction to machine learning with Python.',
        stages: [
          ModuleStage(
            id: 'm_ml_intro',
            moduleId: 'm_ml',
            title: 'Introduction to Machine Learning',
            description: 'What is machine learning? Supervised vs Unsupervised learning.',
            order: 1,
            estimatedMinutes: 90,
            tasks: [
              Task(id: 't_ml_1', stageId: 'm_ml_intro', title: 'Machine Learning Concepts', description: 'Understand the basics of machine learning.', order: 1, estimatedMinutes: 45, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_ml_1', stageId: 'm_ml_intro', title: 'Scikit-learn Tutorial', description: 'Scikit-learn basic tutorial', url: 'https://scikit-learn.org/stable/tutorial/basic/tutorial.html', type: 'documentation', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_ml_scikit',
            moduleId: 'm_ml',
            title: 'Machine Learning with Scikit-Learn',
            description: 'Build and evaluate machine learning models with Scikit-Learn.',
            order: 2,
            estimatedMinutes: 120,
            tasks: [
              Task(id: 't_ml_2', stageId: 'm_ml_scikit', title: 'Scikit-Learn Basics', description: 'Learn how to use Scikit-Learn for machine learning.', order: 1, estimatedMinutes: 60, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_ml_2', stageId: 'm_ml_scikit', title: 'Scikit-learn User Guide', description: 'Scikit-learn comprehensive user guide', url: 'https://scikit-learn.org/stable/user_guide.html', type: 'documentation', isRequired: true),
            ],
          ),
        ],
        difficulty: 'intermediate',
        estimatedHours: 8,
        totalStages: 2,
        totalTasks: 2,
        tags: ['machine-learning', 'python', 'data'],
        createdBy: 'Data Experts',
      ),

      // Design and Mobile Modules
      Module(
        id: 'm_uiux',
        title: 'UI/UX Design Principles',
        description: 'Learn the fundamentals of user interface design.',
        stages: [
          ModuleStage(
            id: 'm_uiux_intro',
            moduleId: 'm_uiux',
            title: 'Introduction to UI/UX Design',
            description: 'Design thinking, user research, and prototyping.',
            order: 1,
            estimatedMinutes: 90,
            tasks: [
              Task(id: 't_uiux_1', stageId: 'm_uiux_intro', title: 'Design Thinking', description: 'Understand the design thinking process.', order: 1, estimatedMinutes: 45, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_uiux_1', stageId: 'm_uiux_intro', title: 'Design Thinking', description: 'Design thinking topics and resources', url: 'https://www.interaction-design.org/literature/topics/design-thinking', type: 'documentation', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_uiux_tools',
            moduleId: 'm_uiux',
            title: 'Design Tools and Prototyping',
            description: 'Using design tools like Sketch, Figma, and Adobe XD.',
            order: 2,
            estimatedMinutes: 120,
            tasks: [
              Task(id: 't_uiux_2', stageId: 'm_uiux_tools', title: 'Prototyping Basics', description: 'Learn how to create prototypes for your designs.', order: 1, estimatedMinutes: 60, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_uiux_2', stageId: 'm_uiux_tools', title: 'Prototyping Tools Guide', description: 'Guide to design prototyping tools', url: 'https://www.smashingmagazine.com/2018/11/guide-to-prototyping-tools/', type: 'documentation', isRequired: true),
            ],
          ),
        ],
        difficulty: 'beginner',
        estimatedHours: 8,
        totalStages: 2,
        totalTasks: 2,
        tags: ['design', 'ui', 'ux'],
        createdBy: 'Design Team',
      ),

      Module(
        id: 'm_patterns',
        title: 'Mobile App Design Patterns',
        description: 'Common patterns for mobile applications.',
        stages: [
          ModuleStage(
            id: 'm_patterns_intro',
            moduleId: 'm_patterns',
            title: 'Introduction to Mobile Design Patterns',
            description: 'Learn about common design patterns in mobile apps.',
            order: 1,
            estimatedMinutes: 90,
            tasks: [
              Task(id: 't_patterns_1', stageId: 'm_patterns_intro', title: 'Design Patterns Overview', description: 'Understand the importance of design patterns.', order: 1, estimatedMinutes: 45, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_patterns_1', stageId: 'm_patterns_intro', title: 'Design Patterns in Flutter', description: 'Introduction to design patterns in Flutter', url: 'https://www.raywenderlich.com/197-introduction-to-design-patterns-in-flutter', type: 'documentation', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_patterns_advanced',
            moduleId: 'm_patterns',
            title: 'Advanced Mobile Design Patterns',
            description: 'Explore advanced design patterns for mobile development.',
            order: 2,
            estimatedMinutes: 120,
            tasks: [
              Task(id: 't_patterns_2', stageId: 'm_patterns_advanced', title: 'Implementing Design Patterns', description: 'Learn how to implement common design patterns.', order: 1, estimatedMinutes: 60, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_patterns_2', stageId: 'm_patterns_advanced', title: 'Understanding Design Patterns', description: 'Understanding design patterns in Flutter', url: 'https://www.smashingmagazine.com/2018/01/understanding-design-patterns-flutter/', type: 'documentation', isRequired: true),
            ],
          ),
        ],
        difficulty: 'intermediate',
        estimatedHours: 8,
        totalStages: 2,
        totalTasks: 2,
        tags: ['mobile', 'design', 'patterns'],
        createdBy: 'Mobile Team',
      ),

      Module(
        id: 'm_accessibility',
        title: 'Accessibility in Mobile Apps',
        description: 'Make your mobile apps accessible to all users.',
        stages: [
          ModuleStage(
            id: 'm_accessibility_intro',
            moduleId: 'm_accessibility',
            title: 'Introduction to Accessibility',
            description: 'Understanding accessibility and its importance.',
            order: 1,
            estimatedMinutes: 60,
            tasks: [
              Task(id: 't_accessibility_1', stageId: 'm_accessibility_intro', title: 'Accessibility Basics', description: 'Learn the basics of accessibility in mobile apps.', order: 1, estimatedMinutes: 30, taskType: 'reading', points: 5),
            ],
            resources: [
              StageResource(id: 'r_accessibility_1', stageId: 'm_accessibility_intro', title: 'W3C Mobile Accessibility', description: 'W3C mobile accessibility guidelines', url: 'https://www.w3.org/WAI/mobile/', type: 'documentation', isRequired: true),
            ],
          ),
          ModuleStage(
            id: 'm_accessibility_testing',
            moduleId: 'm_accessibility',
            title: 'Testing for Accessibility',
            description: 'Tools and techniques for testing accessibility.',
            order: 2,
            estimatedMinutes: 90,
            tasks: [
              Task(id: 't_accessibility_2', stageId: 'm_accessibility_testing', title: 'Accessibility Testing Tools', description: 'Learn about tools for testing accessibility.', order: 1, estimatedMinutes: 45, taskType: 'reading', points: 10),
            ],
            resources: [
              StageResource(id: 'r_accessibility_2', stageId: 'm_accessibility_testing', title: 'Accessibility Testing Tools', description: 'Guide to accessibility testing tools and techniques', url: 'https://www.smashingmagazine.com/2018/03/accessibility-testing-tools-techniques/', type: 'documentation', isRequired: true),
            ],
          ),
        ],
        difficulty: 'beginner',
        estimatedHours: 6,
        totalStages: 2,
        totalTasks: 2,
        tags: ['accessibility', 'mobile', 'design'],
        createdBy: 'Mobile Team',
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

