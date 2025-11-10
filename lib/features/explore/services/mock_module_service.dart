import 'package:skillup/domain/entities/module.dart';
import '../providers/sample_roadmap_data.dart';

class MockModuleService {
  Future<List<Module>> getModules({int? limit}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return sample module list
    final modules = SampleRoadmapData.getSampleModulesList();

    if (limit != null && limit < modules.length) {
      return modules.take(limit).toList();
    }

    return modules;
  }

  Future<Module?> getModuleById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final modules = SampleRoadmapData.getSampleModulesList();
    try {
      return modules.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }
}

