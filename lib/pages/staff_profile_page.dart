import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/auth_controller.dart';
import 'package:flutter_cleancare/controllers/theme_controller.dart';
import 'package:flutter_cleancare/core/routes/app_pages.dart';
import 'package:flutter_cleancare/widgets/app_dialog.dart';
import 'package:get/get.dart';

class StaffProfilePage extends StatelessWidget {
  const StaffProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final themeC = Get.find<ThemeController>();

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.background,),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  final profile = authC.currentUser.value?.profile ?? '';
                  if (profile.isNotEmpty) {
                    AppDialog.showImagePopup(context, profile, isLocal: false);
                  }
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: (authC.currentUser.value?.profile != null &&
                          authC.currentUser.value!.profile.isNotEmpty)
                      ? NetworkImage(authC.currentUser.value!.profile)
                      : null,
                  child: (authC.currentUser.value?.profile == null ||
                          authC.currentUser.value!.profile.isEmpty)
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              Text('ID: ${authC.currentUser.value?.numberId}', style: TextStyle(fontSize: 15)),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.grey[300]),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              'User',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${authC.currentUser.value?.name}'),
          ),
          ListTile(
            leading: const Icon(Icons.badge),
            title: const Text(
              'Role',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(authC.isAdmin ? 'Supervisor' : 'Cleaning Service'),
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text(
              'Pest Control',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(authC.currentUser.value!.name.contains('(Pest Control)') ? 'Yes' : 'No'),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${authC.currentUser.value?.email}'),
          ),
          Divider(color: Colors.grey[300]),
          const SizedBox(height: 20),
          Obx(
            () => ListTile(
              leading: const Icon(Icons.color_lens_rounded),
              title: const Text('Ubah Tema'),
              trailing: Icon(
                themeC.isDarkMode.value
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              onTap: themeC.toggleTheme,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock_reset_rounded),
            title: const Text('Ubah Password'),
            onTap: () {
              Navigator.pushNamed(context, Routes.changePassword);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              AppDialog.confirm(
                title: "Logout",
                message: "Apakah kamu yakin ingin keluar dari aplikasi?",
                confirmColor: Colors.red,
                icon: Icons.logout,
                onConfirm:
                    authC.logout, // panggil logout kalau user menekan "Ya"
              );
            },
          ),
        ],
      ),
    );
  }
}
