class Device {
  final String id;
  final String name;
  final String? vehicleId;
  final String? vehicleName;
  final DeviceStatus status;
  final DeviceLocation? lastLocation;
  final DateTime lastUpdated;
  final Map<String, dynamic>? settings;

  Device({
    required this.id,
    required this.name,
    this.vehicleId,
    this.vehicleName,
    required this.status,
    this.lastLocation,
    required this.lastUpdated,
    this.settings,
  });

  // Create a Device from JSON data
  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as String,
      name: json['name'] as String,
      vehicleId: json['vehicleId'] as String?,
      vehicleName: json['vehicleName'] as String?,
      status: _parseStatus(json['status'] as String),
      lastLocation: json['lastLocation'] != null
          ? DeviceLocation.fromJson(json['lastLocation'] as Map<String, dynamic>)
          : null,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      settings: json['settings'] as Map<String, dynamic>?,
    );
  }

  // Convert Device to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'vehicleId': vehicleId,
      'vehicleName': vehicleName,
      'status': _statusToString(status),
      'lastLocation': lastLocation?.toJson(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'settings': settings,
    };
  }

  // Create a copy of Device with some fields changed
  Device copyWith({
    String? id,
    String? name,
    String? vehicleId,
    String? vehicleName,
    DeviceStatus? status,
    DeviceLocation? lastLocation,
    DateTime? lastUpdated,
    Map<String, dynamic>? settings,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      vehicleId: vehicleId ?? this.vehicleId,
      vehicleName: vehicleName ?? this.vehicleName,
      status: status ?? this.status,
      lastLocation: lastLocation ?? this.lastLocation,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      settings: settings ?? this.settings,
    );
  }

  // Parse status string to enum
  static DeviceStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return DeviceStatus.online;
      case 'offline':
        return DeviceStatus.offline;
      case 'maintenance':
        return DeviceStatus.maintenance;
      case 'charging':
        return DeviceStatus.charging;
      case 'driving':
        return DeviceStatus.driving;
      case 'parked':
        return DeviceStatus.parked;
      default:
        throw ArgumentError('Invalid status: $status');
    }
  }

  // Convert status enum to string
  static String _statusToString(DeviceStatus status) {
    switch (status) {
      case DeviceStatus.online:
        return 'online';
      case DeviceStatus.offline:
        return 'offline';
      case DeviceStatus.maintenance:
        return 'maintenance';
      case DeviceStatus.charging:
        return 'charging';
      case DeviceStatus.driving:
        return 'driving';
      case DeviceStatus.parked:
        return 'parked';
      case DeviceStatus.unknown:
        return 'unknown';
    }
  }

  @override
  String toString() {
    return 'Device{id: $id, name: $name, status: ${_statusToString(status)}}';
  }
}

// Device status enum
enum DeviceStatus {
  online,
  offline,
  maintenance,
  charging,
  driving,
  parked,
  unknown,
}

// Device location class
class DeviceLocation {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? heading;
  final double? speed;
  final DateTime timestamp;
  final double? accuracy;

  DeviceLocation({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.heading,
    this.speed,
    required this.timestamp,
    this.accuracy,
  });

  // Create a DeviceLocation from JSON data
  factory DeviceLocation.fromJson(Map<String, dynamic> json) {
    return DeviceLocation(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      altitude: json['altitude'] as double?,
      heading: json['heading'] as double?,
      speed: json['speed'] as double?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      accuracy: json['accuracy'] as double?,
    );
  }

  // Convert DeviceLocation to JSON
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'heading': heading,
      'speed': speed,
      'timestamp': timestamp.toIso8601String(),
      'accuracy': accuracy,
    };
  }
}