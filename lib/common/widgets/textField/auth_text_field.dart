import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isFormValid;
  final TextInputType? keyboardType;
  final bool isPassword;
  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isFormValid,
    this.keyboardType,
    this.isPassword = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isObscure = true;

  BorderSide _getBorderSide() {
    final Color borderColor = widget.isFormValid ? Colors.black : Colors.grey;
    return BorderSide(color: borderColor, width: 2.0);
  }

  void _toggleVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder customBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: _getBorderSide(),
    );

    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,

      obscureText: widget.isPassword ? _isObscure : false,

      decoration: InputDecoration(
        hintText: widget.hintText,

        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: const Color.fromARGB(255, 157, 157, 157),
                ),
                onPressed: _toggleVisibility,
              )
            : null,

        enabledBorder: customBorder,
        focusedBorder: customBorder,
        border: customBorder,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 10.0,
        ),
      ),
    );
  }
}
