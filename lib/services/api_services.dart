import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../config/env.dart'; // loads BASE_URL, PHONE, PASSWORD, DEVICE_ID
import '../models/position_model.dart';

class ApiService {
  static final String _baseUrl = Env.baseUrl;
  static String get _authHeader {
    final creds = base64Encode(utf8.encode('${Env.phone}:${Env.password}'));
    return 'Basic $creds';
  }

  /// Fetches latest position from OneLap
  static Future<Position?> fetchLatestPosition() async {
    final url = Uri.parse('$_baseUrl/api/positions/latest?deviceId=${Env.deviceId}');
    final resp = await http.get(url, headers: {'Authorization': _authHeader});
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body) as Map<String, dynamic>;
      return Position.fromJson(data);
    }
    return null;
  }
}
