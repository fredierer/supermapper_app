import 'package:flutter/material.dart';
import 'package:supermapper_app/theme.dart';

const double _borderWidth = 3.0;

class ToolNavButton extends StatelessWidget {
  final IconData icon;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final double size;      // taille du bouton (carré)
  final double iconSize;  // taille de l'icône

  const ToolNavButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.textColor = Colors.black,
    this.backgroundColor = AppColors.amber,
    this.size = 48,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: iconSize,
      icon: Icon(icon, color: textColor),
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        elevation: 2,
        shadowColor: Colors.black,
        fixedSize: Size(size, size),
        padding: EdgeInsets.zero, // l'icône reste centrée quelle que soit la taille
        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // évite la zone de tap forcée à 48px
        side: const BorderSide(color: Colors.black, width: _borderWidth),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}