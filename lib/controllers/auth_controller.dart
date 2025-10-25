import 'package:flutter_cleancare/core/routes/app_pages.dart';
import 'package:flutter_cleancare/core/services/api_service.dart';
import 'package:flutter_cleancare/core/services/storage_service.dart';
import 'package:flutter_cleancare/pages/main_page.dart';
import 'package:flutter_cleancare/widgets/app_snackbar_raw.dart';
import 'package:get/get.dart';
import 'package:flutter_cleancare/data/models/user_model.dart';

class AuthController extends GetxController {
  var currentUser = Rxn<User>();
  final obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    final user = await StorageService.getUser();
    if (user != null) {
      currentUser.value = user;
    }
  }

  void login(String userId, String password) async {
    try {
      final response = await ApiService.authLogin(userId, password);

      if (response != null && response['success'] == true) {
        final token = response['data']['token'];
        final responseData = response['data'];
        final user = User.fromJson(responseData);
        currentUser.value = user;
        StorageService.setUser(user.toJson());
        StorageService.setToken(token);
        AppSnackbarRaw.success('Berhasil Login, \nHalo ${user.name}, selamat datang!');
        Get.offAll(() => MainPage());
      } else {
        if (response != null && response['data'] != null) {
          final message = response['data']?['message'] ?? 'Terjadi kesalahan yang tidak diketahui';
          final translatedMessage = message == 'number id or password is incorrect'
              ? 'Nomor ID atau password salah!'
              : message.contains('too many login attempts')
                  ? (() {
                      final regex = RegExp(r'retry after (\d+) seconds');
                      final match = regex.firstMatch(message);
                      if (match != null) {
                        final seconds = match.group(1);
                        return 'Terlalu banyak percobaan login, \nCoba lagi setelah $seconds detik.';
                      }
                      return 'Terlalu banyak percobaan login, \nCoba lagi beberapa saat lagi.';
                    })()
                  : message == 'error validate payload'
                  ? 'Masukkan Nomor ID dan Password!'
                  : message;
          AppSnackbarRaw.error(translatedMessage);
        } else {
          AppSnackbarRaw.error(response?['message'] ?? 'Terjadi kesalahan yang tidak diketahui');
        }
      }
    } catch (e) {
      AppSnackbarRaw.error('$e');
    }
  }

  void logout() {
    ApiService.authLogout();
    currentUser.value = null;
    StorageService.clearAll();
    Get.offAllNamed(Routes.login);
    AppSnackbarRaw.success('Berhasil Logout, \nSampai jumpa kembali!');
  }

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  bool get isAdmin => currentUser.value?.roleName == 'Admin';
}
