//  positioning of the ev
class Position {
  final double latitude;
  final double longitude;

  Position({
    required this.latitude,
    required this.longitude,
  });

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
      );
}
