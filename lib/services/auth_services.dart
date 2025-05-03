import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/env.dart';
import '../models/user.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static User? _currentUser;
  static String? _token;

  // Returns the current user if they're already logged in
  static Future<User?> getCurrentUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }

    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    final token = prefs.getString(_tokenKey);

    if (userData != null && token != null) {
      _token = token;
      _currentUser = User.fromJson(jsonDecode(userData));
      return _currentUser;
    }

    return null;
  }

  // Login with email and password
  static Future<User?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${Env.baseUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String;
        final user = User.fromJson(data['user']);

        // Store token and user data
        await _saveAuthData(token, user);
        
        return user;
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Login failed';
        throw Exception(error);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to login: $e');
    }
  }

  // Register a new user
  static Future<User?> registerUser(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${Env.baseUrl}/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String;
        final user = User.fromJson(data['user']);

        // Store token and user data
        await _saveAuthData(token, user);
        
        return user;
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Registration failed';
        throw Exception(error);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to register: $e');
    }
  }

  // Log out the current user
  static Future<void> logout() async {
    _currentUser = null;
    _token = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    
    try {
      await http.post(
        Uri.parse('${Env.baseUrl}/api/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
    } catch (e) {
      // Ignore logout API errors, as we've already cleared local data
    }
  }

  // Get the authentication token
  static Future<String?> getToken() async {
    if (_token != null) {
      return _token;
    }

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Save authentication data locally
  static Future<void> _saveAuthData(String token, User user) async {
    _token = token;
    _currentUser = user;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
}