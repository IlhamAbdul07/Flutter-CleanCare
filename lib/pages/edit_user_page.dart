import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/users_controller.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';
import 'package:flutter_cleancare/widgets/app_dialog.dart';
import 'package:flutter_cleancare/widgets/app_snackbar_raw.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditUserPage extends StatelessWidget {
  final String userId;
  const EditUserPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final userC = Get.find<UserController>();
    final currentUser = userC.userSingle.value;

    final numberIdC = TextEditingController();
    final nameC = TextEditingController();
    final emailC = TextEditingController();
    final roleList = ['Cleaning Service','Supervisor'];
    final pestControlList = ['No','Yes'];
    final selectedRole = 'Cleaning Service'.obs;
    final selectedPestControl = 'No'.obs;

    if (currentUser == null){
      return const Center(child: Text("no user"));
    }else{
      numberIdC.text = currentUser.numberId;
      nameC.text = currentUser.name.replaceAll(' (Pest Control)', '');
      selectedRole.value = currentUser.roleId == '2' ? 'Cleaning Service' : 'Supervisor';
      selectedPestControl.value = currentUser.name.contains('(Pest Control)') ? 'Yes' : 'No';
      emailC.text = currentUser.email;
      userC.profilC.value = currentUser.profile;
    }

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "Edit Data User",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Obx(() => ListView(
            children: [
              const SizedBox(height: 20),
              Text(
                'Nomor ID',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                controller: numberIdC,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  hintText: "Masukkan Nomor ID",
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Wajib diisi';
                  }
                  if (val.length < 8) {
                    return 'Minimal 8 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              Text(
                'Nama Lengkap',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                controller: nameC,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  hintText: "Masukkan Nama Lengkap",
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 18),
              Text(
                'Role',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
              DropdownButtonFormField<String>(
                initialValue: selectedRole.value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                items: roleList
                    .map(
                      (role) =>
                          DropdownMenuItem(value: role, child: Text(role)),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) selectedRole.value = val;
                },
              ),
              if (selectedRole.value == 'Cleaning Service')...[
                const SizedBox(height: 18,),
                Text(
                  'Pest Control',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
                DropdownButtonFormField<String>(
                  initialValue: selectedPestControl.value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  items: pestControlList
                      .map(
                        (pestControl) =>
                            DropdownMenuItem(value: pestControl, child: Text(pestControl)),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) selectedPestControl.value = val;
                  },
                ),
              ],
              const SizedBox(height: 18),
              Text(
                'Email',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                controller: emailC,
                readOnly: emailC.text == '',
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  hintText: "Masukkan Email",
                ),
                validator: (val) {
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (val == null) {
                    return 'Wajib diisi';
                  } else if (val != '' && !emailRegex.hasMatch(val)) {
                    return 'Format tidak valid';
                  }else{
                    return null;
                  }
                }
              ),
              if (emailC.text == '')...[
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    'Tidak bisa diedit, karena belum verifikasi.',
                    style: const TextStyle(color: Colors.blue, fontSize: 13),
                  ),
                )
              ],
              const SizedBox(height: 18),
              Text(
                'Foto Profil',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
              AbsorbPointer(
                absorbing: emailC.text == '',
                child: GestureDetector(
                  onTap: () => userC.pickImageEdit(),
                  onLongPress: () {
                    final selected = userC.selectedImageEdit.value;
                    final profilUrl = userC.profilC.value;
                    if (selected != null) {
                      AppDialog.showImagePopup(context, selected.path, isLocal: true);
                    } else if (profilUrl.isNotEmpty) {
                      AppDialog.showImagePopup(context, profilUrl, isLocal: false);
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: Obx(() {
                            final selected = userC.selectedImageEdit.value;
                            final profilUrl = userC.profilC.value;
                            if (selected != null) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(selected.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              );
                            } else if (profilUrl.isNotEmpty) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  profilUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) => const Center(
                                    child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                                  ),
                                ),
                              );
                            } else {
                              return const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upload_file, size: 40),
                                    SizedBox(height: 6),
                                    Text(
                                      'Pilih Foto Profil',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => userC.clearImageEdit(),
                        icon: const Icon(Icons.delete, color: Colors.red, size: 28),
                      ),
                    ],
                  ),
                ),
              ),
              if (userC.selectedImageEdit.value != null || userC.profilC.value.isNotEmpty)...[
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    '* Tekan untuk melihat pratinjau',
                    style: const TextStyle(color: Colors.blue, fontSize: 13),
                  ),
                )
              ],
              if (emailC.text == '')...[
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    'Tidak bisa diedit, karena belum verifikasi.',
                    style: const TextStyle(color: Colors.blue, fontSize: 13),
                  ),
                )
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryVariant,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final Map<String, dynamic> data = {};
                      XFile? profile;
                      String contentType = 'application/json';
                      if (numberIdC.text != currentUser.numberId) {
                        data['number_id'] = numberIdC.text;
                      }
                      if (nameC.text != currentUser.name.replaceAll(' (Pest Control)', '')) {
                        data['name'] = nameC.text;
                        if (selectedPestControl.value == 'Yes') {
                          data['name'] = '${nameC.text} (Pest Control)';
                        }
                      }
                      if (selectedPestControl.value != (currentUser.name.contains('(Pest Control)') ? 'Yes' : 'No')) {
                        if (selectedPestControl.value == 'Yes') {
                          data['name'] = '${nameC.text} (Pest Control)';
                        } else {
                          data['name'] = nameC.text;
                        }
                      }
                      if (selectedRole.value != (currentUser.roleId == '2' ? 'Cleaning Service' : 'Supervisor')) {
                        data['role_id'] = selectedRole.value == 'Cleaning Service' ? 2 : 1;
                        if ((selectedRole.value == 'Cleaning Service' ? 2 : 1) == 1) {
                          data['name'] = nameC.text.replaceAll(' (Pest Control)', '');
                        }
                      }
                      if (emailC.text != currentUser.email) {
                        data['email'] = emailC.text;
                      }
                      if (userC.selectedImageEdit.value != null) {
                        profile = userC.selectedImageEdit.value;
                        contentType = 'multipart/form-data';
                      }else if (userC.profilC.value.isEmpty && (userC.profilC.value != currentUser.profile)) {
                        data['delete_profile'] = true;
                      }
                      final result = await userC.updateById(int.parse(userId),data,profile,contentType);
                      if (result == 'ok'){
                        Get.back(result: true);
                        AppSnackbarRaw.success('Berhasil edit user!');
                      }else{
                        AppSnackbarRaw.error(result);
                      }
                    }
                  },
                ),
              ),
            ],
          ),),
        ),
      ),
    );
  }
}
