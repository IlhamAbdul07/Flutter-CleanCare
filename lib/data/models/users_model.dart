class Users {
  final String id;
  final String numberId;
  final String name;
  final String email;
  final String profile;
  final String profileName;
  final String roleId;
  final String roleName;
  final String createdAt;
  final String updatedAt;
  final bool verified;
  final String floor;

  const Users({
    required this.id,
    required this.numberId,
    required this.name,
    required this.email,
    required this.profile,
    required this.profileName,
    required this.roleId,
    required this.roleName,
    required this.createdAt,
    required this.updatedAt,
    required this.verified,
    required this.floor,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id']?.toString() ?? '',
      numberId: json['number_id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profile: json['profile']?['view'] ?? '',
      profileName: json['profile_name'] ?? '',
      roleId: json['role']?['id']?.toString() ?? '',
      roleName: json['role']?['name'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      verified: json['verified'] ?? false,
      floor: json['floor'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number_id': numberId,
      'name': name,
      'email': email,
      'profile': profile,
      'profile_name': profileName,
      'role_id': roleId,
      'role_name': roleName,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'verified': verified,
      'floor': floor,
    };
  }
}