import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbarRaw {
  static void success(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _showSnackbar(
      message: message,
      color1: Colors.green,
      color2: Colors.lightGreen,
      icon: Icons.check_circle,
    );
  }

  static void error(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _showSnackbar(
      message: message,
      color1: Colors.redAccent,
      color2: Colors.red,
      icon: Icons.error_outline,
    );
  }

  static void info(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _showSnackbar(
      message: message,
      color1: Colors.blueAccent,
      color2: Colors.lightBlue,
      icon: Icons.info_outline,
    );
  }

  static void _showSnackbar({
    required String message,
    required Color color1,
    required Color color2,
    required IconData icon,
  }) {
    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      messageText: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color1, color2]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color1.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 3),
    );
  }
}
