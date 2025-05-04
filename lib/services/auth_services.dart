import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'websocket_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/env.dart';
import '../models/user.dart' as app_user; // Alias for your custom User model

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  await FirebaseAuth.instance.signOut();
}

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static app_user.User? currentUser;
  static String? _token;

  static void setCurrentUser(String userJson) {
    currentUser = app_user.User.fromJson(jsonDecode(userJson));
  }
  static String? currentDeviceId;
  
  static Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    WebSocketService.dispose();
    //    await ApiService.dispose(); // Removed or commented out as ApiService is undefined
    currentUser = null;
    currentDeviceId = null;
  }

  // Returns the current user if they're already logged in
  static Future<app_user.User?> getCurrentUser() async {
    if (currentUser != null) {
      return Future.value(currentUser);
    }

    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    final token = prefs.getString(_tokenKey);

    if (userData != null && token != null) {
      _token = token;
      currentUser = app_user.User.fromJson(jsonDecode(userData));
      return Future.value(currentUser);
    }

    return null;
  }

  // Login with email and password
  static Future<app_user.User?> loginUser(String email, String password) async {
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
        final user = app_user.User.fromJson(data['user']);

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
  static Future<app_user.User?> registerUser(String name, String email, String password) async {
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
        final user = app_user.User.fromJson(data['user']);

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
    currentUser = null;
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
  static Future<void> _saveAuthData(String token, app_user.User user) async {
    _token = token;
    currentUser = user;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
}