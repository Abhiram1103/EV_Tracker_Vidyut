import 'package:shared_preferences/shared_preferences.dart';

class DeviceStorage {
  static const _deviceIdKey = 'stored_device_id';

  // Save device ID to local storage
  static Future<void> saveDeviceId(int deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_deviceIdKey, deviceId);
  }

  // Retrieve stored device ID
  static Future<int> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_deviceIdKey) ?? 0; // Returns 0 if not found
  }

  // Clear stored device ID
  static Future<void> clearDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_deviceIdKey);
  }
}