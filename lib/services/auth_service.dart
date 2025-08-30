import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/entities/user_model.dart';

class AuthService {
  static const String userKey = 'user';
  static const String tokenKey = 'token';

  final Map<String, Map<String, String>> _users = {
    'matias@gmail.com': {
      'password': 'admin123',
      'name': 'Admin',
      'role': 'admin',
      'id': '1',
    },
    'user@example.com': {
      'password': 'user123',
      'name': 'Usuario',
      'role': 'user',
      'id': '2',
    },
  };

  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString(userKey);
      if (userStr != null) {
        return User.fromJson(jsonDecode(userStr));
      }
    } catch (e) {
      debugPrint('Error getting current user: $e');
    }
    return null;
  }

  Future<User?> login(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (_users.containsKey(email) && _users[email]!['password'] == password) {
        final userData = _users[email]!;
        final user = User(
          id: userData['id']!,
          email: email,
          name: userData['name']!,
          role: userData['role']!,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(userKey, jsonEncode(user.toJson()));
        await prefs.setString(tokenKey, 'fake-jwt-token');

        return user;
      }
      throw Exception('Credenciales inválidas');
    } catch (e) {
      debugPrint('Error during login: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      debugPrint('Error during logout: $e');
      rethrow;
    }
  }
}
