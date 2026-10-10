import 'package:flutter/material.dart';
import 'package:supermapper_app/theme.dart';

class AddFeedBackButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final EdgeInsets padding;

  const AddFeedBackButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.textColor = Colors.white,
    this.backgroundColor = AppColors.amber,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
      label: Text(
        label, 
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.amber, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}