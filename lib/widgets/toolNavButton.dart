import 'package:flutter/material.dart';
import 'package:supermapper_app/theme.dart';

class ToolNavButton extends StatelessWidget {
  final IconData icon;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final EdgeInsets padding;

  const ToolNavButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.textColor = Colors.white,
    this.backgroundColor = AppColors.amber,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        elevation: 2,
        shadowColor: Colors.black,
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: textColor),
    );
  }
}