class User {
  final String id;
  final String numberId;
  final String name;
  final String email;
  final String createdAt;
  final String profile;
  final String profileName;
  final String roleId;
  final String roleName;

  const User({
    required this.id,
    required this.numberId,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.profile,
    required this.profileName,
    required this.roleId,
    required this.roleName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return User(
      id: data['id']?.toString() ?? '',
      numberId: data['number_id']?.toString() ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      createdAt: data['created_at'] ?? '',
      profile: data['profile']?['view'] ?? '',
      profileName: data['profile_name'] ?? '',
      roleId: data['role']?['id']?.toString() ?? '',
      roleName: data['role']?['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number_id': numberId,
      'name': name,
      'email': email,
      'created_at': createdAt,
      'profile': profile,
      'profile_name': profileName,
      'role_id': roleId,
      'role_name': roleName,
    };
  }
}
