import 'package:flutter/material.dart';

class GlobalLoading {
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
              child: CircularProgressIndicator(color: Colors.black),
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
