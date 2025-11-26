import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/users_controller.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';
import 'package:flutter_cleancare/widgets/app_snackbar_raw.dart';
import 'package:get/get.dart';

class AddUserPage extends StatelessWidget {
  const AddUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userC = Get.find<UserController>();

    final idC = TextEditingController();
    final nameC = TextEditingController();
    final roleList = ['Cleaning Service','Supervisor'];
    final pestControlList = ['No','Yes'];

    final selectedRole = 'Cleaning Service'.obs;
    final selectedPestControl = 'No'.obs;

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "Tambah User Baru",
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
                controller: idC,
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
                  if (val.length < 10) {
                    return 'Minimal 10 karakter';
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
              if (selectedRole == 'Cleaning Service')...[
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
                    "Tambah User",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final result = await userC.create(idC.text, (selectedPestControl.value == 'Yes' ? '${nameC.text} (Pest Control)' : nameC.text), (selectedRole.value == 'Supervisor' ? 1 : 2));
                      if (result == 'ok'){
                        Get.back(result: true);
                        AppSnackbarRaw.success('Berhasil tambah user! \nSilakan regitrasi terlebih dahulu.');
                      }else{
                        if (result == 'number id already exist'){
                          AppSnackbarRaw.error("Nomor ID sudah digunakan pengguna lain.");
                        }else{
                          AppSnackbarRaw.error(result);
                        }
                      }
                    }
                  },
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
