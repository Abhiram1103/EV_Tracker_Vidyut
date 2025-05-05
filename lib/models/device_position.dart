import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class DevicePosition {
  final double latitude;
  final double longitude;
  final double speed;
  final DateTime timestamp;
  final int deviceId;

  const DevicePosition({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.timestamp,
    required this.deviceId,
  });

  factory DevicePosition.fromJson(Map<String, dynamic> json) {
    return DevicePosition(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      speed: (json['speed'] ?? 0.0).toDouble(),
      timestamp: DateTime.parse(json['serverTime'] as String),
      deviceId: json['deviceId'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'speed': speed,
    'timestamp': timestamp.toIso8601String(),
    'deviceId': deviceId,
  };

  @override
  String toString() {
    return 'DevicePosition(lat: $latitude, lng: $longitude, speed: ${speed}km/h)';
  }
}