import 'package:flutter/material.dart';
import 'package:supermapper_app/theme.dart';
import 'package:supermapper_app/widgets/nav_bar_icon.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
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
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 0),
          child: Container(
            color: AppColors.surfaceLight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  color: AppColors.surfaceLight,   
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: const Text(
                    "MY ACCOUNT",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                NavBarIcon(
                  icon: Icons.person_add_alt_1_outlined, 
                  backgroundColor: AppColors.amber,
                  label: "Sign In", 
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'This is not available yet.', 
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 14),
                        ),
                        behavior: SnackBarBehavior.floating, // Rend le SnackBar flottant au-dessus de la BottomBar
                        backgroundColor: Colors.grey.shade500.withAlpha(200),
                        duration: const Duration(milliseconds: 1200), // Durée d'affichage (ex: 3 secondes)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        margin: const EdgeInsets.only(bottom: 90, left: 16, right: 16), // Positionne le message juste au-dessus de la BottomBar
                      ),
                    );
                  }
                ),
              ]
            ),
          )
        )
      ), 
    );
  }

}