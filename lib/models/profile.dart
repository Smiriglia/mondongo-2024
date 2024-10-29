class Profile {
  final String id;
  final String email;
  final String fullName;

  Profile({
    required this.id,
    required this.email,
    required this.fullName,
  });

  // Convierte el JSON a un objeto Profile
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
    );
  }

  // Convierte un objeto Profile a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
    };
  }
}
