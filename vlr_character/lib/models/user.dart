class User {
  final String id;
  final String email;
  final String role;
  final String? name;
  final String? avatar;

  User({
    required this.id,
    required this.email,
    required this.role,
    this.name,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}