import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/user.dart';
import '../models/user_roadmap.dart';

class FirestoreUserService {
  final FirebaseFirestore _firestore;
  final fb.FirebaseAuth _auth;

  FirestoreUserService({FirebaseFirestore? firestore, fb.FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? fb.FirebaseAuth.instance;

  Future<bool> isUsernameUnique(String username) async {
    final snap = await _firestore.collection('users').get();
    final lower = username.toLowerCase();
    for (final doc in snap.docs) {
      final data = doc.data();
      final u = (data['username'] as String?) ?? '';
      if (u.toLowerCase() == lower) {
        // If current user has that username it's okay
        final uid = _auth.currentUser?.uid;
        if (uid != null && doc.id == uid) continue;
        return false;
      }
    }
    return true;
  }

  Future<void> saveUser(User user) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Not signed in');
    final doc = _firestore.collection('users').doc(uid);
    final data = user.toJson();
    await doc.set(data, SetOptions(merge: true));
  }

  Future<User?> getCurrentUser() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    final data = doc.data();
    if (data == null) return null;
    // Firestore may store lists as List<dynamic>
    return User.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> clearCurrentUser() async {
    // No local cache management here. Firestore user doc remains.
    return;
  }

  Future<List<UserRoadmap>> getUserRoadmaps() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];
    final doc = await _firestore.collection('users').doc(uid).get();
    final data = doc.data();
    if (data == null) return [];
    final list = (data['userRoadmaps'] as List<dynamic>?) ?? [];
    return list
        .map((e) => UserRoadmap.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> addRoadmap(String roadmapId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Not signed in');
    final ref = _firestore.collection('users').doc(uid);
    final doc = await ref.get();
    final data = doc.data() ?? {};
    final list = List<Map<String, dynamic>>.from(
      (data['userRoadmaps'] as List<dynamic>?) ?? [],
    );

    if (list.any((e) => (e['roadmapId'] as String) == roadmapId)) return;

    list.add(
      UserRoadmap(roadmapId: roadmapId, startedAt: DateTime.now()).toJson(),
    );
    await ref.set({'userRoadmaps': list}, SetOptions(merge: true));
  }

  Future<void> removeRoadmap(String roadmapId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Not signed in');
    final ref = _firestore.collection('users').doc(uid);
    final doc = await ref.get();
    final data = doc.data() ?? {};
    final list = List<Map<String, dynamic>>.from(
      (data['userRoadmaps'] as List<dynamic>?) ?? [],
    );
    list.removeWhere((e) => (e['roadmapId'] as String) == roadmapId);
    await ref.set({'userRoadmaps': list}, SetOptions(merge: true));
  }

  Future<bool> hasRoadmap(String roadmapId) async {
    final list = await getUserRoadmaps();
    return list.any((r) => r.roadmapId == roadmapId);
  }
}
