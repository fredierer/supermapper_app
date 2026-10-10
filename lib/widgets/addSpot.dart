import 'package:flutter/material.dart';

class AddSpot extends StatefulWidget {
  
  final VoidCallback? onClose; // Fonction optionnelle exécutée lors du clic sur la croix de fermeture
  
  const AddSpot({
    super.key,
    required this.onClose,  
  });

  @override
  State<AddSpot> createState() => _AddSpotState();
}

class _AddSpotState extends State<AddSpot> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        ),
    );
  }
}