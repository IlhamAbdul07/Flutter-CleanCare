import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/auth_controller.dart';
import 'package:get/get.dart';

class StaffProfilePage extends StatelessWidget {
  const StaffProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Column(
          children: [
            CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 10),
            const Text('ID: 10384530324823', style: TextStyle(fontSize: 15)),
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
          subtitle: const Text('Alif Aulia'),
        ),
        ListTile(
          leading: const Icon(Icons.badge),
          title: const Text(
            'Role',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('Staffs'),
        ),
        ListTile(
          leading: const Icon(Icons.business),
          title: const Text(
            'Divisi',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('Cleaning Service'),
        ),
        ListTile(
          leading: const Icon(Icons.email),
          title: const Text(
            'Email',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('alif123@gmail.com'),
        ),
        Divider(color: Colors.grey[300]),
        const SizedBox(height: 20),
        ListTile(
          leading: const Icon(Icons.color_lens_rounded),
          title: const Text('Ubah Tema'),
          onTap: () {
            // Navigate to edit profile page
          },
        ),
        ListTile(
          leading: const Icon(Icons.lock_reset_rounded),
          title: const Text('Ubah Password'),
          onTap: () {
            // Navigate to edit profile page
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () => authC.logout(),
        ),
      ],
    );
  }
}
