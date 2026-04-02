import 'package:flutter/material.dart';
import 'package:trajectoria/common/helper/navigator/page_transitions.dart';

class AppNavigator {
  static void pushReplacement(BuildContext context, Widget widget) {
    Navigator.pushReplacement(context, FadeSlideRoute(page: widget));
  }

  static void push(BuildContext context, Widget widget) {
    Navigator.push(context, FadeSlideRoute(page: widget));
  }

  static void pushAndRemove(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
      context,
      FadeSlideRoute(page: widget),
      (Route<dynamic> route) => false,
    );
  }
}
