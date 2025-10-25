import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/theme_controller.dart';
import 'package:flutter_cleancare/core/bindings/initial_binding.dart';
import 'package:flutter_cleancare/core/routes/app_pages.dart';
import 'package:flutter_cleancare/core/services/storage_service.dart';
import 'package:flutter_cleancare/core/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await StorageService.init();

  final token = StorageService.getToken();
  final initialRoute = (token != null && token.isNotEmpty)
      ? Routes.main
      : Routes.login;

  final themeController = Get.put(ThemeController(), permanent: true);
  runApp(MyApp(initialRoute: initialRoute,themeController: themeController,));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final ThemeController themeController;
  const MyApp({super.key,required this.initialRoute,required this.themeController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        title: 'Clean Care',
        debugShowCheckedModeBanner: false,
        initialBinding: InitialBinding(),
        initialRoute: initialRoute,
        getPages: AppPages.pages,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
      );
    });
  }

}
