import 'package:flutter/material.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';

class GlobalLoadingAi {
  static OverlayEntry? _entry;

  static void show(BuildContext context) {
    if (_entry != null) return;
    final overlay = Overlay.of(context);
    _entry = OverlayEntry(
      builder: (_) => AbsorbPointer(
        absorbing: true,
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 0.5),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(AppImages.aiLoading, width: 80, height: 80),
            ),
          ),
        ),
      ),
    );
    overlay.insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}
