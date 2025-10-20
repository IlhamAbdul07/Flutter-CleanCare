import 'package:flutter_cleancare/data/models/user_model.dart';
import 'package:flutter_cleancare/data/repositories/user_repository.dart';
import 'package:get/get.dart';
import 'package:flutter_cleancare/data/models/users_model.dart';

class UserController extends GetxController {
  final UserRepository _repo = UserRepository();

  var users = <Users>[].obs; // daftar semua user
  var filteredUsers = <Users>[].obs; // hasil pencarian
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    users.value = _repo.getAllUsers();
    filteredUsers.value = users;
  }

  // 🔍 fungsi untuk search
  void searchUser(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredUsers.value = users;
    } else {
      filteredUsers.value = users
          .where((u) => u.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // filter berdasarkan role
  void filterByRole(String role) {
    filteredUsers.value = users.where((u) => u.role == role).toList();
  }

  Future<void> refreshUsers() async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulasi loading
    users.value = _repo.getAllUsers(); // ambil ulang dari repo
    filteredUsers.value = users; // reset hasil filter
  }

  void addUser({
    required String id,
    required String name,
    required String email,
    required String role,
  }) {
    final newUser = User(
      id: id,
      name: name,
      email: email,
      role: role,
      status: 'Active',
      userId: '',
      password: '',
    );
    users.add(newUser as Users);
    update(); // supaya UI reactive
  }
}
