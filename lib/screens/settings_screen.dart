import 'package:flutter/material.dart';
import 'package:supermapper_app/theme.dart';

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
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Not available yet.'),
                        behavior: SnackBarBehavior.floating,
                      ),    
                    );
                  },
                  icon: const Icon(
                    Icons.person_add_alt_1_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'Sign In', 
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amber, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                )
              ]
            ),
          )
        )
      ), 
    );
  }

}