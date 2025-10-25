import 'package:flutter/material.dart';
import 'package:flutter_cleancare/core/routes/app_pages.dart';
import 'package:flutter_cleancare/core/services/api_service.dart';
import 'package:flutter_cleancare/core/services/storage_service.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';
import 'package:flutter_cleancare/widgets/app_snackbar_raw.dart';
import 'package:get/get.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    // Controller input
    final oldPasswordC = TextEditingController();
    final newPasswordC = TextEditingController();
    final confirmPasswordC = TextEditingController();

    // Gunakan ValueNotifier untuk handle toggle password
    final obscureOld = ValueNotifier(true);
    final obscureNew = ValueNotifier(true);
    final obscureConfirm = ValueNotifier(true);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text("Ubah Password", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Text('Password Lama',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ValueListenableBuilder(
                valueListenable: obscureOld,
                builder: (_, value, __) {
                  return TextFormField(
                    controller: oldPasswordC,
                    obscureText: value,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      hintText: "Masukkan password lama",
                      suffixIcon: IconButton(
                        icon: Icon(
                          value ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => obscureOld.value = !value,
                      ),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Wajib diisi' : null,
                  );
                },
              ),

              const SizedBox(height: 18),
              const Text('Password Baru',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ValueListenableBuilder(
                valueListenable: obscureNew,
                builder: (_, value, __) {
                  return TextFormField(
                    controller: newPasswordC,
                    obscureText: value,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      hintText: "Masukkan password baru",
                      suffixIcon: IconButton(
                        icon: Icon(
                          value ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => obscureNew.value = !value,
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Wajib diisi';
                      if (val.length < 8) {
                        return 'Password baru minimal 8 karakter';
                      }
                      if (val == oldPasswordC.text) {
                        return 'Password baru tidak boleh sama dengan password lama';
                      }
                      return null;
                    },
                  );
                },
              ),

              const SizedBox(height: 18),
              const Text('Konfirmasi Password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ValueListenableBuilder(
                valueListenable: obscureConfirm,
                builder: (_, value, __) {
                  return TextFormField(
                    controller: confirmPasswordC,
                    obscureText: value,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      hintText: "Masukkan ulang password baru",
                      suffixIcon: IconButton(
                        icon: Icon(
                          value ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => obscureConfirm.value = !value,
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Wajib diisi';
                      if (val != newPasswordC.text) {
                        return 'Konfirmasi password harus sama dengan password baru';
                      }
                      return null;
                    },
                  );
                },
              ),

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
                    "Simpan Password",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final user = await StorageService.getUser();
                      final data = {
                        "old_password": oldPasswordC.text,
                        "new_password": newPasswordC.text,
                      };
                      final response = await ApiService.handleUser(method: 'PATCH',userId: int.parse(user!.id),data: data,contentType: "application/json");
                      if (response != null && response['success'] == true) {
                        ApiService.authLogout();
                        StorageService.clearAll();
                        Get.offAllNamed(Routes.login);
                        AppSnackbarRaw.success('Password berhasil diubah!');
                      } else {
                        final errorData = response?['data'];
                        final message = errorData['message'] ?? 'Terjadi kesalahan tidak diketahui';
                        if (message == 'old password is wrong') {
                          AppSnackbarRaw.error("Password lama anda salah.");
                        } else {
                          AppSnackbarRaw.error(message);
                        }
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
