import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _backendUrl = 'http://<YOUR_BACKEND>/'; // e.g. http://10.0.2.2:5000/

  /// Call /login on your Flask backend. Expects JSON {access_token: "..."}
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$_backendUrl/login');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (resp.statusCode == 200) {
      final token = jsonDecode(resp.body)['access_token'] as String;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt', token);
      return true;
    }
    return false;
  }

  /// Retrieve the stored JWT
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }
}
