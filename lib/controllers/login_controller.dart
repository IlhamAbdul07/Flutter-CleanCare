import 'package:flutter_cleancare/core/routes/app_pages.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  final AuthController authC = Get.find();
  var obscurePassword = true.obs;

  void togglePassword() => obscurePassword.toggle();

  void login(String userId, String password) {
    authC.login(userId, password);
  }

  void goToRegister() {
    Get.toNamed(Routes.register);
  }

  void goToForgotPassword() {
    Get.toNamed(Routes.forgotPassword);
  }
}
