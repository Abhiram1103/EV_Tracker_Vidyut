import 'package:http/http.dart' as http;
import '../config/env.dart';
import '../models/device.dart';
import 'dart:convert';
import '../models/device_position.dart';

class ApiService {
  // Add new device (From API docs)
  static Future<Device> addDevice(String imei, {String? name}) async {
    final response = await http.post(
      Uri.parse('${Env.baseUrl}/api/devices'),
      headers: {
        'Authorization': _basicAuthHeader,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'uniqueld': imei, // Note: API docs use "uniqueld" (likely typo)
      }),
    );

    if (response.statusCode == 201) {
      return Device.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to add device: ${response.body}');
  }

  // Get latest position (From API docs)
  static Future<DevicePosition> getLatestPosition(int deviceId) async {
    final response = await http.get(
      Uri.parse('${Env.baseUrl}/api/positions/latest?deviceId=$deviceId'),
      headers: {'Authorization': _basicAuthHeader},
    );

    if (response.statusCode == 200) {
      return DevicePosition.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to get latest position: ${response.body}');
  }

  // Updated position history (From API docs)
  static Future<List<DevicePosition>> getPositionHistory(
    int deviceId, {
    required DateTime from,
    required DateTime to,
  }) async {
    final uri = Uri.parse(
      '${Env.baseUrl}/api/reports/mini-route?'
      'deviceId=$deviceId&'
      'from=${from.toUtc().toIso8601String()}&'
      'to=${to.toUtc().toIso8601String()}'
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': _basicAuthHeader},
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((p) => DevicePosition.fromJson(p))
          .toList();
    }
    throw Exception('Failed to load position history: ${response.body}');
  }

  // Original methods (keep if needed)
  static Future<List<Device>> getDevices() async {
    final response = await http.get(
      Uri.parse('${Env.baseUrl}/api/devices'),
      headers: {'Authorization': _basicAuthHeader},
    );
    
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((d) => Device.fromJson(d))
          .toList();
    }
    throw Exception('Failed to load devices: ${response.body}');
  }

  // Helper method for Basic Auth header
  static String get _basicAuthHeader {
    final creds = base64Encode(utf8.encode('${Env.phone}:${Env.password}'));
    return 'Basic $creds';
  }

  // Remove unused methods: 
  // - updateDeviceSettings
  // - sendDeviceCommand
  // - getDeviceLocationHistory (replaced by getPositionHistory)
  // - initialize/dispose (not needed for HTTP client)
}