import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

extension ToastExtension on BuildContext {
  void showSuccessToast(String message) {
    MotionToast.success(
      title: const Text(
        "Berhasil",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      description: Text(message, style: const TextStyle(color: Colors.white)),
      width: 300,
      height: 80,
      borderRadius: 10,
    ).show(this);
  }

  void showErrorToast(String message) {
    MotionToast.error(
      title: const Text(
        "Gagal",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      description: Text(message, style: const TextStyle(color: Colors.white)),
      width: 300,
      height: 80,
      borderRadius: 10,
    ).show(this);
  }
}
