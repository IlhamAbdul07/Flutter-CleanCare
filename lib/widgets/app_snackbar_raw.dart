import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbarRaw {
  /// ✅ SUCCESS
  static void success(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _showSnackbar(
      message: message,
      icon: Icons.check_circle_outline,
      type: _SnackbarType.success,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// ✅ ERROR
  static void error(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _showSnackbar(
      message: message,
      icon: Icons.error_outline,
      type: _SnackbarType.error,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// ✅ INFO
  static void info(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _showSnackbar(
      message: message,
      icon: Icons.info_outline,
      type: _SnackbarType.info,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// ⚙️ Core Snackbar Builder
  static void _showSnackbar({
    required String message,
    required IconData icon,
    required _SnackbarType type,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    // --- Ambil ThemeData dari context aktif GetX
    final context = Get.context;
    final theme = context != null ? Theme.of(context) : ThemeData.light();
    final colorScheme = theme.colorScheme;

    // --- Warna dinamis tergantung tipe snackbar & theme aktif
    final isDark = theme.brightness == Brightness.dark;

    Color primaryColor;
    Color secondaryColor;

    switch (type) {
      case _SnackbarType.success:
        primaryColor = isDark ? Colors.green.shade700 : Colors.green;
        secondaryColor = isDark ? Colors.green.shade400 : Colors.lightGreen;
        break;
      case _SnackbarType.error:
        primaryColor = isDark ? Colors.red.shade700 : Colors.redAccent;
        secondaryColor = isDark ? Colors.red.shade400 : Colors.red;
        break;
      case _SnackbarType.info:
        primaryColor = isDark ? Colors.blue.shade700 : Colors.blueAccent;
        secondaryColor = isDark ? Colors.blue.shade400 : Colors.lightBlue;
        break;
    }

    final textColor = colorScheme.onPrimary;
    final actionColor = colorScheme.onPrimary.withOpacity(0.9);

    // --- Snackbar dengan gaya modern & gradient adaptif
    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      duration: const Duration(seconds: 3),
      messageText: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.35),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(foregroundColor: actionColor),
                child: Text(
                  actionLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: actionColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 🔒 Enum internal untuk menentukan tipe snackbar
enum _SnackbarType { success, error, info }


