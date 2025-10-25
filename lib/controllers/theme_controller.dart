import 'package:flutter/material.dart';
import 'package:flutter_cleancare/core/services/storage_service.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Reactive state
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = StorageService.loadTheme();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    StorageService.saveTheme(isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
