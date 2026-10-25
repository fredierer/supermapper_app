import 'package:flutter/material.dart';
import 'package:supermapper_app/theme.dart';

class ClusterBubble extends StatelessWidget {
  final int count;
  const ClusterBubble({required this.count});

  @override
  Widget build(BuildContext context) {
    final double innerSize = count < 10
        ? 40
        : count < 50
            ? 46
            : 50;

    final String label = count > 99 ? '99+' : '$count';
    final double fontSize = label.length >= 3 ? 12 : 15;

    return Center(
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.amber.withAlpha(60),
        ),
        alignment: Alignment.center,
        child: Container(
          width: innerSize,
          height: innerSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.amber, AppColors.orange],
            ),
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.orange.withAlpha(110),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: fontSize,
              letterSpacing: 0.3,
              shadows: const [
                Shadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}