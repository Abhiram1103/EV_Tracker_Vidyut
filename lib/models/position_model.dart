class Position {
  final double latitude;
  final double longitude;
  final DateTime fixTime;

  Position({
    required this.latitude,
    required this.longitude,
    required this.fixTime,
  });

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
        fixTime: DateTime.parse(json['fixTime'] as String),
      );
}
