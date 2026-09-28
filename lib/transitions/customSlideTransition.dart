import 'package:flutter/material.dart';

Route customSlidefromLeft(Widget page) {
  return PageRouteBuilder(
    // Durée de la transition (optionnel)
    transitionDuration: const Duration(milliseconds: 500),
    
    // Écran à afficher
    pageBuilder: (context, animation, secondaryAnimation) => page,
    
    // Animation appliquée
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // 1. Définir le point de départ et le point d'arrivée
      // Offset(1.0, 0.0) = Écran positionné à droite (hors champ)
      // Offset.zero = Position finale (centré)
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      
      // 2. Choisir une courbe d'animation (ex: easeInOut)
      const curve = Curves.easeInOut;

      // 3. Combiner le départ/arrivée avec la courbe
      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      // 4. Appliquer la transition SlideTransition
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route customSlidefromRight(Widget page) {
  return PageRouteBuilder(
    // Durée de la transition (optionnel)
    transitionDuration: const Duration(milliseconds: 500),
    
    // Écran à afficher
    pageBuilder: (context, animation, secondaryAnimation) => page,
    
    // Animation appliquée
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // 1. Définir le point de départ et le point d'arrivée
      // Offset(1.0, 0.0) = Écran positionné à droite (hors champ)
      // Offset.zero = Position finale (centré)
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      
      // 2. Choisir une courbe d'animation (ex: easeInOut)
      const curve = Curves.easeInOut;

      // 3. Combiner le départ/arrivée avec la courbe
      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      // 4. Appliquer la transition SlideTransition
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}