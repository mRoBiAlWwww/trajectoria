import 'package:flutter/material.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Widget content;
  final bool isBordered;
  final double horizontalPadding;
  final double verticalPadding;
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
    this.horizontalPadding = 0,
    this.verticalPadding = 0,
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
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    );

    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      padding: padding,
      minimumSize: const Size(double.infinity, 55),
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

// class BasicAppButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed;
//   final Color backgroundColor;
//   const BasicAppButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     required this.backgroundColor,
//   });
//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = backgroundColor.computeLuminance() < 0.5;
//     final Color foregroundColor = isDark ? Colors.white : Colors.black;
//     final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
//       minimumSize: const Size(double.infinity, 55),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//       backgroundColor: backgroundColor,
//       foregroundColor: foregroundColor,
//       disabledBackgroundColor: backgroundColor,
//       disabledForegroundColor: Colors.white,
//       elevation: 0,
//     );
//     final Widget initialChild = Text(
//       text,
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//     );
//     final Widget loadingChild = SizedBox(
//       height: 24,
//       width: 24,
//       child: CircularProgressIndicator(color: foregroundColor, strokeWidth: 3),
//     );
//     return BlocBuilder<ButtonStateCubit, ButtonState>(
//       builder: (context, state) {
//         final bool isLoading = state is ButtonLoadingState;
//         return ElevatedButton(
//           style: buttonStyle,
//           onPressed: isLoading ? null : onPressed,
//           child: isLoading ? loadingChild : initialChild,
//         );
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// class BasicAppButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed;
//   final Color backgroundColor;
//   const BasicAppButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     required this.backgroundColor,
//   });
//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = backgroundColor.computeLuminance() < 0.5;
//     final Color foregroundColor = isDark ? Colors.white : Colors.black;
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         minimumSize: const Size(double.infinity, 55),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//         backgroundColor: backgroundColor,
//         foregroundColor: foregroundColor,
//         elevation: 0,
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }
