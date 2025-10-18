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
                            const Text(
                              "Clean Care",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
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
                              'Employee ID',
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
                                  text: c.employeeData.value?.userId ?? '',
                                ),
                                readOnly: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
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
                                  text: c.employeeData.value?.role ?? '',
                                ),
                                readOnly: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
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
                                decoration: const InputDecoration(
                                  hintText: 'Masukkan email anda',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
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
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: 'Masukkan password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        c.obscurePassword.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: c.togglePassword,
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: 'Masukkan kembali password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        c.obscurePassword.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: c.togglePassword,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //Button Daftar
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  c.employeeData.value?.name;
                                  c.employeeData.value?.userId;
                                  c.employeeData.value?.role;
                                  c.register(emailC.text, passwordC.text);
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
                            const SizedBox(height: 12),
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
