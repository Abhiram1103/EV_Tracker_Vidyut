import 'package:http/http.dart' as http;
import '../config/env.dart';
import '../models/device.dart';
import 'dart:convert';

class ApiService {
  // Fetch all devices for the current user
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
    throw Exception('Failed to load devices');
  }

  // Fetch a specific device by ID
  static Future<Device> getDevice(String deviceId) async {
    final response = await http.get(
      Uri.parse('${Env.baseUrl}/api/devices/$deviceId'),
      headers: {'Authorization': _basicAuthHeader},
    );
    
    if (response.statusCode == 200) {
      return Device.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load device with ID: $deviceId');
  }

  // Update device settings
  static Future<Device> updateDeviceSettings(String deviceId, Map<String, dynamic> settings) async {
    final response = await http.patch(
      Uri.parse('${Env.baseUrl}/api/devices/$deviceId/settings'),
      headers: {
        'Authorization': _basicAuthHeader,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'settings': settings}),
    );
    
    if (response.statusCode == 200) {
      return Device.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update device settings');
  }

  // Send a command to the device
  static Future<bool> sendDeviceCommand(String deviceId, String command, Map<String, dynamic> params) async {
    final response = await http.post(
      Uri.parse('${Env.baseUrl}/api/devices/$deviceId/command'),
      headers: {
        'Authorization': _basicAuthHeader,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'command': command,
        'parameters': params,
      }),
    );
    
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['success'] == true;
    }
    throw Exception('Failed to send command to device');
  }

  // Get device location history
  static Future<List<DeviceLocation>> getDeviceLocationHistory(
    String deviceId, {
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  }) async {
    final queryParams = <String, String>{};
    
    if (startTime != null) {
      queryParams['startTime'] = startTime.toIso8601String();
    }
    
    if (endTime != null) {
      queryParams['endTime'] = endTime.toIso8601String();
    }
    
    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }
    
    final uri = Uri.parse('${Env.baseUrl}/api/devices/$deviceId/locations')
        .replace(queryParameters: queryParams);
        
    final response = await http.get(
      uri,
      headers: {'Authorization': _basicAuthHeader},
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((location) => DeviceLocation.fromJson(location)).toList();
    }
    throw Exception('Failed to load device location history');
  }

  // Helper method for Basic Auth header
  static String get _basicAuthHeader {
    final creds = base64Encode(utf8.encode('${Env.phone}:${Env.password}'));
    return 'Basic $creds';
  }
}