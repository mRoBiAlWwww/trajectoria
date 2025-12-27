import 'package:flutter/material.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Widget content;
  final bool isBordered;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Color? borderColor;
  final Color? foregroundColor;
  final double? borderRad;

  const BasicAppButton({
    super.key,
    this.onPressed,
    required this.backgroundColor,
    required this.content,
    this.borderColor,
    this.isBordered = false,
    this.horizontalPadding,
    this.verticalPadding,
    this.foregroundColor,
    this.borderRad,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = backgroundColor.computeLuminance() < 0.5;
    // final Color foregroundColor = isDark ? Colors.white : Colors.black;
    final Color resolvedForegroundColor =
        foregroundColor ?? (isDark ? Colors.white : Colors.black);

    final padding = EdgeInsets.symmetric(
      horizontal: horizontalPadding ?? 0,
      vertical: verticalPadding ?? 15,
    );

    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      padding: padding,
      minimumSize: Size(horizontalPadding == null ? double.infinity : 0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRad ?? 100),
        side: isBordered
            ? BorderSide(
                color: borderColor ?? Colors.black,
                width: 1.0,
                style: BorderStyle.solid,
              )
            : BorderSide.none,
      ),
      backgroundColor: backgroundColor,
      // foregroundColor: foregroundColor,
      foregroundColor: resolvedForegroundColor,
      disabledBackgroundColor: AppColors.disableBackgroundButton,
      disabledForegroundColor: AppColors.disableTextButton,
      elevation: 0,
    );

    return ElevatedButton(
      style: buttonStyle,
      onPressed: onPressed,
      child: content,
    );
  }
}
