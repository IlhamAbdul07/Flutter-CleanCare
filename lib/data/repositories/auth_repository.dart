import 'package:flutter_cleancare/data/models/user_model.dart';

class AuthRepository {
  // Static list user dummy
  final List<User> _users = const [
    User(
      userId: 'admin',
      password: '12345',
      role: 'admin',
      id: '',
      name: '',
      email: '',
      status: '',
    ),
    User(
      userId: 'staff1',
      password: '12345',
      role: 'staff',
      id: '',
      name: '',
      email: '',
      status: '',
    ),
    User(
      userId: 'staff2',
      password: '12345',
      role: 'staff',
      id: '',
      name: '',
      email: '',
      status: '',
    ),
  ];

  User? login(String userId, String password) {
    try {
      return _users.firstWhere(
        (u) => u.userId == userId && u.password == password,
      );
    } catch (e) {
      return null;
    }
  }
}
