import 'package:skillup/domain/entities/roadmap.dart';
import '../providers/sample_roadmap_data.dart';

class MockRoadmapService {
  Future<List<Roadmap>> getRoadmaps() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Return sample domain Roadmap list
    return SampleRoadmapData.getSampleRoadmapList();
  }
}
