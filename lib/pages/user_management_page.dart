import 'package:flutter/material.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';
import 'package:flutter_cleancare/pages/add_user_page.dart';
import 'package:get/get.dart';
import 'package:flutter_cleancare/controllers/users_controller.dart';
import 'package:flutter_cleancare/data/models/users_model.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userC = Get.put(UserController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'User Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [],
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔍 Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari pengguna...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: userC.searchUser,
            ),
            const SizedBox(height: 8),

            // 📋 Daftar user (reactive)
            Expanded(
              child: Obx(() {
                final users = userC.filteredUsers;

                return RefreshIndicator(
                  onRefresh: () async {
                    await userC
                        .refreshUsers(); // 🔁 panggil fungsi refresh dari controller
                  },
                  child: users.isEmpty
                      ? const Center(child: Text("Tidak ada user ditemukan."))
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 10,
                          ),
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return _buildUserTile(user);
                            },
                          ),
                        ),
                );
              }),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    Get.to(() => const AddUserPage());
                  },
                  icon: const Icon(Icons.add),
                  tooltip: 'Tambah User',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget terpisah agar rapi
  Widget _buildUserTile(Users user) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: user.status == 'Active' ? Colors.green : Colors.grey,
          child: Text(user.name[0]),
        ),
        title: Text(user.name),
        subtitle: Text('${user.role} • ${user.email}'),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: () {
          // ke halaman detail nanti
          Get.snackbar('Detail', 'Klik user: ${user.name}');
        },
      ),
    );
  }
}
