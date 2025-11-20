import 'package:flutter/material.dart';

class RoundedOrNotButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isBordered;
  final Color? customBackgroundColor;
  final Color? customBorderColor;

  const RoundedOrNotButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isBordered = false,
    this.customBackgroundColor,
    this.customBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color foregroundColor = isBordered ? Colors.black : Colors.white;
    final Color backgroundColor = isBordered ? Colors.white : Colors.black;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),

        shape: isBordered
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: const BorderSide(
                  color: Colors.black,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              )
            : const RoundedRectangleBorder(borderRadius: BorderRadius.zero),

        backgroundColor: customBackgroundColor ?? backgroundColor,
        foregroundColor: foregroundColor,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}
