import 'package:flutter/material.dart';
import 'package:supermapper_app/shells/homeShell.dart';
import 'package:supermapper_app/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_PUBLISHABLEKEY']!,
  );

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