
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ApiService {
  static Future<LatLng?> fetchLatestPosition() async {
    final baseUrl = dotenv.env['BASE_URL'];
    final deviceId = dotenv.env['DEVICE_ID'];
    final phone = dotenv.env['PHONE'];
    final password = dotenv.env['PASSWORD'];

    final authHeader = 'Basic ' + base64Encode(utf8.encode('\$phone:\$password'));
    final response = await http.get(
      Uri.parse('\$baseUrl/\$deviceId/location'),
      headers: {'authorization': authHeader},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return LatLng(data['lat'], data['lng']);
    }
    return null;
  }
}
