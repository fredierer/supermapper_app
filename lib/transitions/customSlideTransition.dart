import 'package:flutter/material.dart';

Route<T> customSlidefromLeft<T>(Widget page) {
  return PageRouteBuilder<T>(
    // Durée de la transition (optionnel)
    transitionDuration: const Duration(milliseconds: 500),
    
    // Écran à afficher
    pageBuilder: (context, animation, secondaryAnimation) => page,
    
    // Animation appliquée
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route<T> customSlidefromRight<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 500),
    
    pageBuilder: (context, animation, secondaryAnimation) => page,
    
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}



Route<T> customSlidefromBottom<T>(Widget page) {
  return PageRouteBuilder<T>(
    // Durée de la transition (optionnel)
    transitionDuration: const Duration(milliseconds: 800),
    
    // Écran à afficher
    pageBuilder: (context, animation, secondaryAnimation) => page,
    
    // Animation appliquée
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
