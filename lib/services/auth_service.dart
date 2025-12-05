import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  static const String _keyCurrentUser = 'current_user';

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_keyCurrentUser);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> saveCurrentUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrentUser, jsonEncode(user.toJson()));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentUser);
  }

  Future<UserModel?> login(String email, String password, String role) async {
    // Mock authentication
    await Future.delayed(const Duration(seconds: 1));

    // For demo purposes, accept any email/password combination
    if (email.isNotEmpty && password.isNotEmpty) {
      final user = UserModel(
        id: const Uuid().v4(),
        name: _getNameFromEmail(email),
        email: email,
        role: role,
        phoneNumber: '9876543210',
      );

      await saveCurrentUser(user);
      return user;
    }

    return null;
  }

  String _getNameFromEmail(String email) {
    final name = email.split('@')[0];
    return name
        .split('.')
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }
}
