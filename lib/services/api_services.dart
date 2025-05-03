import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/position_model.dart';
import '../config/env.dart'; // Make sure this file exists and exports your env vars

class ApiService {
  static const _baseUrl = BASE_URL; // from env.dart

  static Future<PositionModel?> fetchLatestPosition() async {
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$PHONE:$PASSWORD'))}';

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/locations/$DEVICE_ID'),
        headers: {'authorization': basicAuth},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Assume the latest record is the last one
        if (data is List && data.isNotEmpty) {
          final latest = data.last;

          final lat = double.tryParse(latest['latitude'].toString());
          final lng = double.tryParse(latest['longitude'].toString());

          if (lat != null && lng != null) {
            return PositionModel(latitude: lat, longitude: lng);
          }
        }
      } else {
        print("API Error: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("API Exception: $e");
    }

    return null;
  }
}
