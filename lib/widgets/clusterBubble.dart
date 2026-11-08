import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supermapper_app/theme.dart';

const double _borderWidth = 3.0;

class ClusterBubble extends StatelessWidget {
  final int count;
  const ClusterBubble({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final double size = count < 10
        ? 42
        : count < 50
            ? 48
            : 54;

    final String label = count > 99 ? '99+' : '$count';
    final double fontSize = label.length >= 3 ? 12 : 15;

    return Center(
      child: SizedBox(
        width: 56,
        height: 56,
        child: Center(
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 255, 251, 242),
              border: Border.all(color: AppColors.amber, width: _borderWidth),
            ),
            child: Text(
              label,
              style: GoogleFonts.spaceMono(
                color: AppColors.amber,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}