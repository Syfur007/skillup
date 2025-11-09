import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/user_roadmap.dart';

class MockUserService {
  static const _usersKey = 'mock_users';
  static const _currentUserKey = 'current_user';

  Future<List<User>> _loadSavedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null || raw.isEmpty) return [];
    final list = json.decode(raw) as List<dynamic>;
    return list.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<bool> isUsernameUnique(String username) async {
    final users = await _loadSavedUsers();
    return !users.any(
      (u) => u.username.toLowerCase() == username.toLowerCase(),
    );
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _loadSavedUsers();
    // add user to list (replace if same username)
    users.removeWhere(
      (u) => u.username.toLowerCase() == user.username.toLowerCase(),
    );
    users.add(user);
    await prefs.setString(
      _usersKey,
      json.encode(users.map((u) => u.toJson()).toList()),
    );
    await prefs.setString(_currentUserKey, json.encode(user.toJson()));
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_currentUserKey);
    if (raw == null) return null;
    return User.fromJson(json.decode(raw) as Map<String, dynamic>);
  }

  Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  Future<List<UserRoadmap>> getUserRoadmaps() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('user_roadmaps');
    if (raw == null) return [];
    final list = json.decode(raw) as List;
    return list.map((e) => UserRoadmap.fromJson(e)).toList();
  }

  Future<void> addRoadmap(String roadmapId) async {
    final prefs = await SharedPreferences.getInstance();
    final roadmaps = await getUserRoadmaps();

    // Check if already added
    if (roadmaps.any((r) => r.roadmapId == roadmapId)) return;

    roadmaps.add(UserRoadmap(roadmapId: roadmapId, startedAt: DateTime.now()));

    await prefs.setString(
      'user_roadmaps',
      json.encode(roadmaps.map((r) => r.toJson()).toList()),
    );
  }

  Future<void> removeRoadmap(String roadmapId) async {
    final prefs = await SharedPreferences.getInstance();
    final roadmaps = await getUserRoadmaps();
    roadmaps.removeWhere((r) => r.roadmapId == roadmapId);
    await prefs.setString(
      'user_roadmaps',
      json.encode(roadmaps.map((r) => r.toJson()).toList()),
    );
  }

  Future<bool> hasRoadmap(String roadmapId) async {
    final roadmaps = await getUserRoadmaps();
    return roadmaps.any((r) => r.roadmapId == roadmapId);
  }
}
