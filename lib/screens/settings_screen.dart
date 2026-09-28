import 'package:flutter/material.dart';
import 'package:supermapper_app/theme.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceLight,
        scrolledUnderElevation: 0, 
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text("Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            fontSize: 28,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 10),
          child: Column()
        )
      ), 
    );
  }

}