import 'package:flutter/material.dart';
import 'package:supermapper_app/shells/homeShell.dart';
import 'package:supermapper_app/theme.dart';

void main() {
  runApp(const MastroApp());
}

class MastroApp extends StatelessWidget {
  const MastroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supermapper',
      theme: appTheme,
      home: HomeShell(),
    );
  }
}