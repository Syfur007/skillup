import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillup/domain/entities/module.dart';

class FirestoreModuleService {
  final FirebaseFirestore _firestore;

  FirestoreModuleService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Module>> getModules({int? limit}) async {
    Query query = _firestore.collection('modules').where('isPublished', isEqualTo: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    final snap = await query.get();
    return snap.docs.map((d) {
      final data = Map<String, dynamic>.from(d.data() as Map);
      data['id'] = d.id;
      return Module.fromJson(data);
    }).toList();
  }

  Future<Module?> getModuleById(String id) async {
    final doc = await _firestore.collection('modules').doc(id).get();
    if (!doc.exists) return null;

    final data = Map<String, dynamic>.from(doc.data()!);
    data['id'] = doc.id;
    return Module.fromJson(data);
  }
}

