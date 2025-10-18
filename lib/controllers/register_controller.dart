import 'package:flutter_cleancare/data/models/register_model.dart';
import 'package:get/get.dart';
import 'package:flutter_cleancare/data/repositories/register_repository.dart';

class RegisterController extends GetxController {
  final RegisterRepository _repo = RegisterRepository();

  var step = 1.obs;
  final isIdValidated = false.obs;
  final isLoading = false.obs;
  final employeeData = Rxn<Register>();
  var obscurePassword = true.obs;

  void togglePassword() => obscurePassword.toggle();

  void validateEmployeeId(String id) {
    isLoading.value = true;
    final result = _repo.validateEmployeeId(id);
    isLoading.value = false;

    if (result != null) {
      employeeData.value = result;
      isIdValidated.value = true;
      step.value = 2;

      Get.snackbar('Berhasil', 'ID ditemukan: ${result.name}');
    } else {
      Get.snackbar('Gagal', 'ID tidak ditemukan!');
    }
  }

  void register(String email, String password) {
    if (employeeData.value == null) {
      Get.snackbar('Error', 'Validasi ID dulu sebelum registrasi.');
      return;
    }

    final success = _repo.register(email, password);

    if (success) {
      Get.snackbar('Sukses', 'Registrasi berhasil! Silakan login.');
      Get.offAllNamed('/login');
    } else {
      Get.snackbar('Gagal', 'Terjadi kesalahan saat registrasi.');
    }
  }

  void resetForm() {
    employeeData.value = null;
    isIdValidated.value = false;
  }

  void backToLogin() {
    Get.offAllNamed('/login');
  }

  void backToStep1() {
    step.value = 1;
  }
}
