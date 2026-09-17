import 'package:flutter/material.dart';
import 'package:supermapper_app/theme.dart';

class LowBandButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const LowBandButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Coins bien arrondis
          side: BorderSide(color: Colors.white.withOpacity(0.1)), // Bordure subtile
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size:40),
            Text(label, style: TextStyle(fontSize: 12),)
          ],
        ),
      ),
    );
  }
}