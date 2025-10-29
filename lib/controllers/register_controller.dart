import 'package:flutter_cleancare/core/routes/app_pages.dart';
import 'package:flutter_cleancare/core/services/api_service.dart';
import 'package:flutter_cleancare/data/models/register_model.dart';
import 'package:flutter_cleancare/widgets/app_snackbar_raw.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController {
  var step = 1.obs;
  final isIdValidated = false.obs;
  final isLoading = false.obs;
  final employeeData = Rxn<Register>();
  var obscurePassword = true.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;
  var photoError = ''.obs;
  var selectedImage = Rx<XFile?>(null);

  void togglePassword() => obscurePassword.toggle();

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = image;
      photoError.value = '';
    }
  }

  bool validate(String email, String password, String confirmPassword) {
    bool isValid = true;
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

    if (email.isEmpty) {
      emailError.value = 'Email wajib diisi';
      isValid = false;
    } else if (!emailRegex.hasMatch(email)) {
      emailError.value = 'Format email tidak valid';
      isValid = false;
    }

    if (password.isEmpty) {
      passwordError.value = 'Password wajib diisi';
      isValid = false;
    } else if (password.length < 8) {
      passwordError.value = 'Password minimal 8 karakter';
      isValid = false;
    }

    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = 'Konfirmasi password wajib diisi';
      isValid = false;
    } else if (confirmPassword != password) {
      confirmPasswordError.value =
          'Konfirmasi password harus sama dengan password';
      isValid = false;
    }

    return isValid;
  }

  Future<void> validateEmployeeId(String id) async {
    isLoading.value = true;
    final response = await ApiService.authVerifyNumber(id);
    // final result = _repo.validateEmployeeId(id);
    isLoading.value = false;

    if (response != null && response['success'] == true) {
      final responsData = response['data'];
      final userRegist = Register.fromJson(responsData);
      employeeData.value = userRegist;
      isIdValidated.value = true;
      step.value = 2;
      AppSnackbarRaw.success('Nomor ID ditemukan, \nHalo ${userRegist.name}!');
    } else {
      final errorData = response?['data'];
      final message = errorData['message'] ?? 'Terjadi kesalahan tidak diketahui';
      if (message == 'user already registered') {
        AppSnackbarRaw.error("Nomor ID sudah terdaftar, \nSilakan login.");
      } else if (message == 'wrong id number' || message == 'error validate payload') {
        AppSnackbarRaw.error("Nomor ID tidak ditemukan.");
      } else {
        AppSnackbarRaw.error(message);
      }
    }
  }

  Future<void> register(String numberId, String email, String password, XFile? profile) async {
    final Map<String, dynamic> data = {
      'number_id': numberId,
      'email': email,
      'password': password,
    };
    final List<http.MultipartFile> files = [];
    if (profile != null) {
      final file = await http.MultipartFile.fromPath('profile', profile.path);
      files.add(file);
    }

    final response = await ApiService.authRegister(data, files);

    if (response != null && response['success'] == true) {
      AppSnackbarRaw.success('Registrasi berhasil! \nSilakan login.');
      Get.offAllNamed(Routes.login);
    } else {
      final errorMessage = response!['data']?['message'] ??
          response['message'] ??
          'Terjadi kesalahan saat registrasi.';
      if (errorMessage == 'email already exist'){
        AppSnackbarRaw.error("Email sudah digunakan pengguna lain.");
      }else{
        AppSnackbarRaw.error(errorMessage);
      }
    }
  }

  void backToLogin() {
    Get.offAllNamed(Routes.login);
  }

  void backToStep1() {
    step.value = 1;
  }
}
