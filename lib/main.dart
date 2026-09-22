import 'package:flutter/material.dart';
import 'package:supermapper_app/screens/map_screen.dart';
import 'package:supermapper_app/theme.dart';

void main() {
  runApp(const MastroApp());
}

class MastroApp extends StatelessWidget {
  const MastroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mastro',
      theme: appTheme,
      home: const MapScreen(),
    );
  }
}