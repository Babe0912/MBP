class Character {
  final String id;
  final String name;
  final String role;
  final String skills;

  Character({
    required this.id,
    required this.name,
    required this.role,
    required this.skills,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id']?.toString() ?? '', // ถ้า id เป็น null จะใช้ค่าเริ่มต้น ''
      name: json['name']?.toString() ?? 'Unknown',  // ถ้าชื่อเป็น null จะใช้ "Unknown"
      role: json['role']?.toString() ?? 'Unknown role',  // จัดการ role เป็นค่าเริ่มต้นถ้า null
      skills: json['skills']?.toString() ?? 'Unknown skills',  // จัดการ skills เป็นค่าเริ่มต้นถ้า null
    );
  }
}
