class Register {
  final String id;
  final String numberId;
  final String name;
  final String createdAt;
  final String roleId;
  final String roleName;

  const Register({
    required this.id,
    required this.numberId,
    required this.name,
    required this.createdAt,
    required this.roleId,
    required this.roleName,
  });

  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
      id: json['id']?.toString() ?? '',
      numberId: json['number_id']?.toString() ?? '',
      name: json['name'] ?? '',
      createdAt: json['created_at'] ?? '',
      roleId: json['role']?['id']?.toString() ?? '',
      roleName: json['role']?['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number_id': numberId,
      'name': name,
      'created_at': createdAt,
      'role_id': roleId,
      'role_name': roleName,
    };
  }
}
