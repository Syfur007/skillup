import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

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
}
