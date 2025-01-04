import 'package:flutter/material.dart';
import 'package:pay_roll/shared/contants.dart';

class ButtonWidget extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final Color color;
  final Color foregroundColor;
  final String text;
  final IconData? icon;
  const ButtonWidget({
    super.key,
    this.color = primaryColor,
    this.foregroundColor = Colors.white,
    required this.isLoading,
    required this.onPressed,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(icon, size: 22, color: foregroundColor),
                  ],
                ],
              ),
      ),
    );
  }
}
