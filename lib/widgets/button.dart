import 'package:flutter/material.dart';
import 'package:supermapper_app/theme.dart';

class Button extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, // Fond blanc épuré
          foregroundColor: AppColors.background, // Couleur du texte / icône
          elevation: 0,
          minimumSize: const Size(double.infinity, 50), // Hauteur fixe de 52px, largeur responsive
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Bordure fine
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}