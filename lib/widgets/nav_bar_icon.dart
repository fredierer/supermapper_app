import 'package:flutter/material.dart';

class NavBarIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final EdgeInsets padding;

  const NavBarIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: textColor),
      label: Text(label, style: TextStyle(color: textColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}