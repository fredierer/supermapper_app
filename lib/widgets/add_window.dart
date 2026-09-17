import 'package:flutter/material.dart';
import 'package:supermapper_app/theme.dart';

class AddWindow extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(20, 15, 20, 0),
      title: const Text("Add a new feedback", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary,) ,textAlign: TextAlign.center,),
      contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 10),
      actionsPadding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      backgroundColor: AppColors.background.withAlpha(150),
      shadowColor: Colors.black,
      content: SizedBox(
        child: Text(
          "Select which type of feedback you want to provide :", 
          style: TextStyle(
            fontSize: 12,
            color: AppColors.primary.withValues(alpha: 120)
          ),
          textAlign: TextAlign.center,
        ),

      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary, // Fond blanc épuré
            foregroundColor: AppColors.background, // Couleur du texte / icône
            elevation: 0,
            fixedSize: const Size(150, 120), // Hauteur fixe de 52px, largeur responsive
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Bordure fine
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pin_drop, size: 24,),
              Text(
                "Location",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  
                ),
              ),
              Text(
                "Local point for a coffee place, a meeting spot, ...",
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(width: 10,),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary, // Fond blanc épuré
            foregroundColor: AppColors.background, // Couleur du texte / icône
            elevation: 0,
            fixedSize: const Size(150, 120), // Hauteur fixe de 52px, largeur responsive
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Bordure fine
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.route, size: 24,),
              Text(
                "Multiple steps",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  
                ),
              ),
              Text(
                "For a trace, a path to follow, a route with instructions",
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

      ],
    );



  }


}