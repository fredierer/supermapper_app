import 'package:flutter/material.dart';

class NavBarButton extends StatelessWidget {
  final IconData icon;
  final Color textColor;
  final VoidCallback onPressed;
  final EdgeInsets padding;

  const NavBarButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.textColor = Colors.black,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: textColor),
      iconSize: 30.0,
    );
  }
}