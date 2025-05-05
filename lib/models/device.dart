class Device {
  final int id;
  final String name;
  final String imei;

  const Device({
    required this.id,
    required this.name,
    required this.imei,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as int, // Ensure int type
      name: json['name'] as String? ?? 'Unnamed Device',
      imei: json['uniqueld'] as String, // Match API response field
    );
  }
}