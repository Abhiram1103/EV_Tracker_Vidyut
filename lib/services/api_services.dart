import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/position_model.dart';

class ApiService {
  static final String _baseUrl = dotenv.env['BASE_URL']!;
  static final String _phone = dotenv.env['PHONE']!;
  static final String _password = dotenv.env['PASSWORD']!;
  static final String _deviceId = dotenv.env['DEVICE_ID']!;

  /// Builds the Authorization header (Basic Auth as used by OneLap)
  static String _buildAuthHeader() {
    final credentials = base64Encode(utf8.encode('$_phone:$_password'));
    return 'Basic $credentials';
  }

  /// Fetch latest position of the vehicle
  static Future<Position?> fetchLatestPosition() async {
    try {
      final url = Uri.parse('$_baseUrl/track/$_deviceId');
      final response = await http.get(url, headers: {
        'Authorization': _buildAuthHeader(),
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final lat = double.tryParse(data['latitude'].toString());
        final lng = double.tryParse(data['longitude'].toString());

        if (lat != null && lng != null) {
          return Position(latitude: lat, longitude: lng);
        }
      } else {
        debugprint('Failed to fetch location: ${response.statusCode}');
      }
    } catch (e) {
      debugprint('API Error: $e');
    }

    return null;
  }
}
