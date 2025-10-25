import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterStepFormWidget extends StatelessWidget {
  const RegisterStepFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(RegisterController());
    final emailC = TextEditingController();
    final passwordC = TextEditingController();
    final passwordCC = TextEditingController();
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Bagian atas
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 120,
                              width: 120,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Clean Care",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bagian bawah
                    Expanded(
                      flex: 4,
                      child: Container(
                        width: double.infinity,

                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Daftar Akun",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            //ID
                            const SizedBox(height: 10),
                            Text(
                              'Nomor ID',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 50,
                              child: TextField(
                                controller: TextEditingController(
                                  text: c.employeeData.value?.numberId ?? '',
                                ),
                                readOnly: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            // Nama
                            const SizedBox(height: 15),
                            Text(
                              'Nama Karyawan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 50,
                              child: TextField(
                                controller: TextEditingController(
                                  text: c.employeeData.value?.name ?? '',
                                ),
                                readOnly: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            // Role
                            const SizedBox(height: 15),
                            Text(
                              'Role',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 50,
                              child: TextField(
                                controller: TextEditingController(
                                  text: (c.employeeData.value?.roleName ?? '') == 'Admin' ? 'Supervisor' : 'Cleaning Service',
                                ),
                                readOnly: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            // Email
                            const SizedBox(height: 15),
                            Text(
                              'Email',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 50,
                              child: TextField(
                                controller: emailC,
                                onChanged: (_) {
                                    c.emailError.value = '';
                                  },
                                decoration: const InputDecoration(
                                  hintText: 'Masukkan email anda',
                                  border: OutlineInputBorder(),
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            Obx(() => c.emailError.value.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 6, left: 4),
                                    child: Text(
                                      c.emailError.value,
                                      style: const TextStyle(color: Colors.red, fontSize: 13),
                                    ),
                                  )
                                : const SizedBox()),
                            // Password
                            const SizedBox(height: 15),
                            Text(
                              'Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 50,
                              child: Obx(
                                () => TextField(
                                  obscureText: c.obscurePassword.value,
                                  controller: passwordC,
                                  onChanged: (_) {
                                    c.passwordError.value = '';
                                  },
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: 'Masukkan password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        c.obscurePassword.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      onPressed: c.togglePassword,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            Obx(() => c.passwordError.value.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 6, left: 4),
                                    child: Text(
                                      c.passwordError.value,
                                      style: const TextStyle(color: Colors.red, fontSize: 13),
                                    ),
                                  )
                                : const SizedBox()),
                            // PasswordConfirm
                            const SizedBox(height: 20),
                            Text(
                              'Konfirmasi Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 50,
                              child: Obx(
                                () => TextField(
                                  obscureText: c.obscurePassword.value,
                                  controller: passwordCC,
                                  onChanged: (_) {
                                    c.passwordError.value = '';
                                  },
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: 'Masukkan kembali password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        c.obscurePassword.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      onPressed: c.togglePassword,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            Obx(() => c.confirmPasswordError.value.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 6, left: 4),
                                    child: Text(
                                      c.confirmPasswordError.value,
                                      style: const TextStyle(color: Colors.red, fontSize: 13),
                                    ),
                                  )
                                : const SizedBox()),
                            // FOTO PROFIL (WAJIB)
                            const SizedBox(height: 20),
                            Text(
                              'Foto Profil',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 8),
                            Obx(() => GestureDetector(
                                  onTap: () => c.pickImage(),
                                  child: Container(
                                    height: 140,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: c.photoError.value.isNotEmpty
                                            ? Colors.red
                                            : Colors.transparent,
                                      ),
                                    ),
                                    child: c.selectedImage.value != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.file(
                                              File(c.selectedImage.value!.path),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Center(
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
                                          ),
                                  ),
                                )),
                            Obx(() => c.photoError.value.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 6, left: 4),
                                    child: Text(
                                      c.photoError.value,
                                      style:
                                          const TextStyle(color: Colors.red, fontSize: 13),
                                    ),
                                  )
                                : const SizedBox()),
                            //Button Daftar
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  final isValid = c.validate(emailC.text, passwordC.text, passwordCC.text);
                                  if (isValid) {
                                    if (c.selectedImage.value == null) {
                                      c.photoError.value = 'Foto profil wajib diisi';
                                      return;
                                    }
                                    c.register(c.employeeData.value!.numberId, emailC.text, passwordC.text, c.selectedImage.value);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.primaryBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Kembali ke ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                InkWell(
                                  onTap: c.backToStep1,
                                  child: const Text(
                                    'Verifikasi Nomor ID',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1,
                                    endIndent: 10, // jarak dari teks
                                  ),
                                ),
                                Text("atau", style: TextStyle(color: Colors.white)),
                                Expanded(
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1,
                                    indent: 10, // jarak dari teks
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Kembali ke ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                InkWell(
                                  onTap: c.backToLogin,
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
