import 'package:flutter/material.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';

class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColor.primary,
      secondary: AppColor.secondary,
      surface: Colors.white,
      background: Colors.white,
      error: AppColor.error,
    ),
    scaffoldBackgroundColor: Colors.white,
  );

  static final dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: AppColor.primaryBlue,
      secondary: AppColor.secondaryVariant,
      surface: const Color(0xFF1E1E1E),
      background: const Color(0xFF121212),
      error: AppColor.error,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
  );
}
