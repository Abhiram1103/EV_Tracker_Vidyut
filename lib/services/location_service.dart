import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Check if location services are enabled
  static Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permissions
  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Get current device position
  static Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,  // Corrected parameter name
    );
  }

  /// Get position stream
  static Stream<Position> get positionStream {
    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,  // Changed from desiredAccuracy
      distanceFilter: 10,  // Meters
    );
    
    return Geolocator.getPositionStream(
      locationSettings: locationSettings,
    );
  }
}