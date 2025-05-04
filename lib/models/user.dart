class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime createdAt;
  final List<String>? vehicleIds;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.createdAt,
    this.vehicleIds,
  });

  factory User.fromFirebaseUser(dynamic firebaseUser) {
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      name: firebaseUser.displayName ?? '',
      photoUrl: firebaseUser.photoURL,
      createdAt: DateTime.now(),
      vehicleIds: [],
    );
  }

  // Create a User from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      vehicleIds: (json['vehicleIds'] as List?)?.map((e) => e as String).toList(),
    );
  }

  // Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'vehicleIds': vehicleIds,
    };
  }

  // Create a copy of User with some fields changed
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
    List<String>? vehicleIds,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      vehicleIds: vehicleIds ?? this.vehicleIds,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email}';
  }
}