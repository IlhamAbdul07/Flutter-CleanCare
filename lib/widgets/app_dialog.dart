import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  /// 🔹 Dialog konfirmasi umum (bisa untuk logout, hapus, simpan, dll)
  static void confirm({
    required String title,
    required String message,
    String confirmText = "Ya",
    String cancelText = "Batal",
    Color? confirmColor,
    IconData icon = Icons.help_outline,
    VoidCallback? onConfirm,
  }) {
    final context = Get.context;
    final theme = context != null ? Theme.of(context) : ThemeData.light();
    final scheme = theme.colorScheme;

    final Color bgColor = scheme.surface;
    final Color textColor = scheme.onSurface;
    final Color buttonTextColor = scheme.onPrimary;

    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      backgroundColor: bgColor,
      barrierDismissible: false,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: confirmColor ?? scheme.primary, size: 48),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.9)),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: scheme.primary),
                  ),
                  child: Text(
                    cancelText,
                    style: TextStyle(color: scheme.primary),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmColor ?? scheme.primary,
                  ),
                  onPressed: () {
                    Get.back(); // tutup dialog
                    if (onConfirm != null) onConfirm();
                  },
                  child: Text(
                    confirmText,
                    style: TextStyle(color: buttonTextColor),
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
    Color? color,
  }) {
    final context = Get.context;
    final theme = context != null ? Theme.of(context) : ThemeData.light();
    final scheme = theme.colorScheme;

    final Color bgColor = scheme.surface;
    final Color textColor = scheme.onSurface;
    final Color mainColor = color ?? scheme.primary;

    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(24),
      backgroundColor: bgColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: mainColor, size: 48),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.9)),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(backgroundColor: mainColor),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  static void editComment({
    required String initialValue,
    required Function(String) onSave,
  }) {
    final context = Get.context;
    final theme = context != null ? Theme.of(context) : ThemeData.light();
    final scheme = theme.colorScheme;

    final Color bgColor = scheme.surface;
    final Color textColor = scheme.onSurface;
    final Color mainColor = scheme.primary;

    final TextEditingController commentC = TextEditingController(
      text: initialValue,
    );

    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      backgroundColor: bgColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit_note_rounded, color: mainColor, size: 48),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              "Edit Komentar",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: commentC,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Tulis komentar baru...",
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: mainColor, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: scheme.primary),
                  ),
                  child: Text("Batal", style: TextStyle(color: scheme.primary)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                  onPressed: () {
                    onSave(commentC.text);
                    Get.back();
                  },
                  child: const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

