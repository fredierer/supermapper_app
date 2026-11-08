import 'package:flutter/material.dart';
import 'package:supermapper_app/theme.dart';

const double _borderWidth = 3.0;

class NavBarButton extends StatelessWidget {
  final IconData icon;
  final Color textColor;
  final VoidCallback onPressed;
  final bool isActive;

  const NavBarButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.textColor = Colors.black,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: textColor),
      iconSize: 28.0,
      style: IconButton.styleFrom(
        backgroundColor: isActive ? AppColors.amber : Colors.transparent,
        fixedSize: const Size(52, 52),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(
          color: isActive ? Colors.black : Colors.transparent,
          width: _borderWidth,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}