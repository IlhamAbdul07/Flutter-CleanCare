import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/users_controller.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';
import 'package:flutter_cleancare/pages/edit_user_page.dart';
import 'package:flutter_cleancare/widgets/app_dialog.dart';
import 'package:flutter_cleancare/widgets/app_snackbar_raw.dart';
import 'package:get/get.dart';

class DetailUserPage extends StatelessWidget {
  final String userId;
  const DetailUserPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final userC = Get.find<UserController>();
    userC.getById(int.parse(userId));

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Detail User",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.primary,
      ),
      body: Obx(() {
        final user = userC.userSingle.value;

        return RefreshIndicator(
          onRefresh: () async {
            await userC.getById(int.parse(userId));
          },
          child: user == null
              ? const Center(child: Text("no user"))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          final profileUrl = user.profile;
                          if (profileUrl.isNotEmpty) {
                            AppDialog.showImagePopup(context, profileUrl, isLocal: false);
                          }
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: (user.profile.isNotEmpty)
                              ? NetworkImage(user.profile)
                              : null,
                          child: (user.profile.isEmpty)
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        leading: Icon(
                          Icons.perm_contact_cal_sharp,
                          color: AppColor.primary,
                        ),
                        title: const Text(
                          'Nomor ID',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                        subtitle: Text(user.numberId, style: TextStyle(fontSize: 14)),
                      ),
                      const Divider(height: 5,),
                      ListTile(
                        leading: Icon(Icons.person, color: AppColor.primary),
                        title: const Text(
                          'Nama Lengkap',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                        subtitle: Text(user.name.replaceAll(' (Pest Control)', ''), style: TextStyle(fontSize: 14)),
                      ),
                      const Divider(height: 5,),
                      ListTile(
                        leading: Icon(Icons.badge, color: AppColor.primary),
                        title: const Text(
                          'Role',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                        subtitle: Text(user.roleId == '1' ? 'Supervisor' : 'Cleaning Service', style: TextStyle(fontSize: 14)),
                      ),
                      const Divider(height: 5,),
                      if (user.roleId == '2')...[
                        ListTile(
                          leading: Icon(Icons.badge, color: AppColor.primary),
                          title: const Text(
                            'Pest Control',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          ),
                          subtitle: Text(user.name.contains('(Pest Control)') ? 'Yes' : 'No', style: TextStyle(fontSize: 14)),
                        ),
                        const Divider(height: 5,),
                        ListTile(
                          leading: Icon(Icons.layers, color: AppColor.primary),
                          title: const Text(
                            'Penempatan',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          ),
                          subtitle: Text(user.floor, style: TextStyle(fontSize: 14)),
                        ),
                        const Divider(height: 5,),
                      ],
                      ListTile(
                        leading: Icon(Icons.email, color: AppColor.primary),
                        title: const Text(
                          'Email',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                        subtitle: Text((user.email == '' ? '-' : user.email), style: TextStyle(fontSize: 14)),
                      ),
                      const Divider(height: 5,),
                      ListTile(
                        leading: Icon(user.email == '' ? Icons.remove_circle : Icons.check_circle, color: user.email == '' ? Colors.red : Colors.green),
                        title: const Text(
                          'Status',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                        subtitle: Text(
                          (user.email == '' ? 'Belum Verifikasi' : "Terverifikasi"),
                          style: TextStyle(fontSize: 14, color: user.email == '' ? Colors.red : Colors.green),
                        ),
                      ),
                      const Divider(height: 5,),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.primaryBlue,
                                  iconColor: Colors.white,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  final result = await Get.to(() => EditUserPage(userId: user.id));
                                  if (result == true) {
                                    userC.clearImageEdit();
                                    userC.getById(int.parse(userId));
                                  }else{
                                    userC.clearImageEdit();
                                    userC.getById(int.parse(userId));
                                  }
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  iconColor: Colors.white,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  AppDialog.confirm(
                                    title: "Hapus User",
                                    message: "Apakah kamu yakin ingin menghapus user ini?",
                                    confirmColor: Colors.red,
                                    icon: Icons.delete,
                                    onConfirm: () async {
                                      final result = await userC.deleteById(int.parse(user.id));
                                      if (result == 'ok'){
                                        Get.back(result: true);
                                        AppSnackbarRaw.success('Berhasil hapus user!');
                                      }else{
                                        AppSnackbarRaw.error(result);
                                      }
                                    },
                                  );
                                },
                                icon: const Icon(Icons.delete),
                                label: const Text('Delete'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
