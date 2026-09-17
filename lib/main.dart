import 'package:flutter/material.dart';
import 'package:supermapper_app/screens/map_screen.dart';

void main() {
  runApp(const MastroApp());
}

class MastroApp extends StatelessWidget {
  const MastroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mastro',
      home: const mapScreen(),
    );
  }
}