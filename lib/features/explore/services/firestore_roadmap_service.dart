import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillup/domain/entities/roadmap.dart';

class FirestoreRoadmapService {
  final FirebaseFirestore _firestore;

  FirestoreRoadmapService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Roadmap>> getRoadmaps() async {
    final snap = await _firestore.collection('roadmaps').get();
    return snap.docs.map((d) {
      // Domain Roadmap.fromJson expects a map that includes the id
      final data = Map<String, dynamic>.from(d.data());
      data['id'] = d.id;
      return Roadmap.fromJson(data);
    }).toList();
  }

  Future<void> createRoadmap({
    required String title,
    String? description,
    String? category,
    String? iconName,
    List<RoadmapStage>? stages,
  }) async {
    final doc = _firestore.collection('roadmaps').doc();
    await doc.set({
      'title': title,
      'description': description ?? '',
      'category': category ?? '',
      'iconName': iconName ?? '',
      'stages': stages?.map((s) => s.toJson()).toList() ?? [],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
