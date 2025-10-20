import 'package:flutter_cleancare/pages/main_page.dart';
import 'package:flutter_cleancare/widgets/app_snackbar_raw.dart';
import 'package:get/get.dart';
import 'package:flutter_cleancare/data/models/user_model.dart';
import 'package:flutter_cleancare/data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepo = AuthRepository();
  var currentUser = Rxn<User>();
  final obscurePassword = true.obs;

  void login(String userId, String password) {
    final user = _authRepo.login(userId, password);

    if (user != null) {
      currentUser.value = user;
      Get.offAll(() => MainPage());
    } else {
      Get.snackbar('Login Gagal', 'User ID atau password salah!');
    }
  }

  void logout() {
    currentUser.value = null;
    Get.offAllNamed('/login');
    AppSnackbarRaw.success('Kamu telah logout dari aplikasi.');
  }

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  bool get isAdmin => currentUser.value?.role == 'admin';
  bool get isStaff => currentUser.value?.role == 'staff';
}
