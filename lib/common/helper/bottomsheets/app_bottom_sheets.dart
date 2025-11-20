import 'package:flutter/material.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';

class AppBottomsheet {
  static Future<void> display(BuildContext context, Widget widget) {
    return showModalBottomSheet(
      backgroundColor: AppColors.splashBackground,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      builder: (_) {
        return widget;
      },
    );
  }
}
