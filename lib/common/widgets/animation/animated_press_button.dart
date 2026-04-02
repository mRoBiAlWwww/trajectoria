import 'package:flutter/material.dart';

/// Wraps any child widget with a subtle scale-down effect on press.
///
/// Usage:
/// ```dart
/// AnimatedPressButton(
///   onPressed: () { ... },
///   child: BasicAppButton(...),
/// )
/// ```
class AnimatedPressButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double pressedScale;

  const AnimatedPressButton({
    super.key,
    required this.child,
    this.onPressed,
    this.pressedScale = 0.96,
  });

  @override
  State<AnimatedPressButton> createState() => _AnimatedPressButtonState();
}

class _AnimatedPressButtonState extends State<AnimatedPressButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? (_) => _setPressed(true) : null,
      onTapUp: widget.onPressed != null
          ? (_) {
              _setPressed(false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel:
          widget.onPressed != null ? () => _setPressed(false) : null,
      child: AnimatedScale(
        scale: _isPressed ? widget.pressedScale : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }

  void _setPressed(bool value) {
    if (_isPressed != value) setState(() => _isPressed = value);
  }
}
