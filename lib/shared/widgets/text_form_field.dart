import 'package:pay_roll/shared/contants.dart';
import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final bool isRequired;
  final Widget? suffixIcon;
  final bool obscureText;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool enabled;
  final String? Function(String?)? validator;

  const TextFormFieldWidget({
    super.key,
    this.onTap,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    required this.keyboardType,
    this.isRequired = true,
    this.suffixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.4),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onTap: onTap,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: const TextStyle(color: textSecondaryColor),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: const Color(0xFF293646),
                )
              : null,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        validator: validator ??
            (isRequired
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your $hintText';
                    }
                    return null;
                  }
                : null),
      ),
    );
  }
}
