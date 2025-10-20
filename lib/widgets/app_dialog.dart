import 'package:flutter/material.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';
import 'package:get/get.dart';

class AppDialog {
  /// 🔹 Dialog konfirmasi umum (bisa untuk logout, hapus, simpan, dll)
  static void confirm({
    required String title,
    required String message,
    String confirmText = "Ya",
    String cancelText = "Batal",
    Color confirmColor = Colors.red,
    IconData icon = Icons.help_outline,
    VoidCallback? onConfirm,
  }) {
    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      backgroundColor: Colors.white,
      barrierDismissible: false,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: confirmColor, size: 48),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    cancelText,
                    style: TextStyle(color: AppColor.primary),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmColor,
                  ),
                  onPressed: () {
                    Get.back(); // tutup dialog
                    if (onConfirm != null) onConfirm();
                  },
                  child: Text(
                    confirmText,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔹 Dialog informasi (tanpa tombol aksi)
  static void info({
    required String title,
    required String message,
    IconData icon = Icons.info_outline,
    Color color = Colors.blue,
  }) {
    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(24),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 48),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(backgroundColor: color),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
