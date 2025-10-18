import 'package:flutter_cleancare/pages/forgot_password_page.dart';
import 'package:flutter_cleancare/pages/login_page.dart';
import 'package:flutter_cleancare/pages/main_page.dart';
import 'package:flutter_cleancare/pages/register_page.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.login, page: () => LoginPage()),
    GetPage(name: Routes.main, page: () => MainPage()),
    GetPage(name: Routes.register, page: () => RegisterPage()),
    GetPage(name: Routes.forgotPassword, page: () => ForgotPasswordPage()),
  ];
}
