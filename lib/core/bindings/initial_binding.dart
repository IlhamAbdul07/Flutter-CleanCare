import 'package:flutter_cleancare/controllers/auth_controller.dart';
import 'package:flutter_cleancare/controllers/main_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Register controllers that need to be available app-wide
    // permanent: true agar tidak ter-dispose otomatis
    Get.put(AuthController(), permanent: true);
    Get.put(MainController(), permanent: true);
  }
}
