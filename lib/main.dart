import 'package:flutter/material.dart';
import 'package:flutter_cleancare/core/bindings/initial_binding.dart';
import 'package:flutter_cleancare/core/routes/app_pages.dart';
import 'package:flutter_cleancare/core/services/storage_service.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi SharedPreferences dulu (async)
  await StorageService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Clean Care',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(), // inject controller/service global
      initialRoute: Routes.login,
      getPages: AppPages.pages,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
