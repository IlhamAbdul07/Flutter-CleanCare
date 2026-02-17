import 'package:flutter/material.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';
import 'package:flutter_cleancare/pages/add_user_page.dart';
import 'package:flutter_cleancare/pages/detail_user_page.dart';
import 'package:get/get.dart';
import 'package:flutter_cleancare/controllers/users_controller.dart';
import 'package:flutter_cleancare/data/models/users_model.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userC = Get.put(UserController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'User Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                userC.exportUsers();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.primary,
                ),
                child: const Icon(Icons.download, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
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
            
                Obx(() => Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: userC.sortOrder.value,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'A-Z', child: Text('Sort A-Z')),
                          DropdownMenuItem(value: 'Z-A', child: Text('Sort Z-A')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            userC.sortUsers(value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
            
                    // Filter Dropdown
                    Flexible(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: userC.filterRole.value,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Supervisor',
                            child: Text(
                              'Supervisor',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Cleaning Service',
                            child: Text(
                              'Cleaning Service',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            userC.filterUsersByRole(value);
                          }
                        },
                      ),
                    ),
                  ],
                )),
            
                const SizedBox(height: 8),
            
                // 📋 Daftar user (reactive)
                Expanded(
                  child: Obx(() {
                    final users = userC.users;
            
                    return RefreshIndicator(
                      onRefresh: () async {
                        await userC.refreshUsers();
                      },
                      child: users.isEmpty
                          ? const Center(child: Text("Mohon tunggu, sedang menyiapkan data."))
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
              ],
            ),

            // positioned
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  color: Colors.white,
                  iconSize: 28,
                  icon: const Icon(Icons.add),
                  tooltip: 'Tambah User',
                  onPressed: () async {
                    final result = await Get.to(() => AddUserPage());
                    if (result == true) {
                      userC.refreshUsers();
                    }else{
                      userC.refreshUsers();
                    }
                  },
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
    final userC = Get.put(UserController());

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: (user.profile.isNotEmpty)
                    ? NetworkImage(user.profile)
                    : null,
          backgroundColor: user.verified ? Colors.green : Colors.grey,
          child: (user.profile.isEmpty)
                    ? Text(user.name[0],style: TextStyle(color: Colors.white),)
                    : null,
        ),
        title: Text(user.name),
        subtitle: user.roleName == 'Admin'
          ? const Text('Supervisor')
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Cleaning Service'),
                const SizedBox(width: 8),
                if (user.floor.isNotEmpty) ...[
                  const Icon(Icons.layers, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    user.floor.replaceAll('Lantai ', ''),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ],
            ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: () async {        
          final result = await Get.to(() => DetailUserPage(userId: user.id));
          if (result == true) {
            userC.refreshUsers();
          }else{
            userC.refreshUsers();
          }
        },
      ),
    );
  }
}
