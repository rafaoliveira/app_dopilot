import 'package:flutter/material.dart';

/// Cores principais do DoPilot
class AppColors {
  static const Color primaryPurple = Color(0xFF7B2CBF);
  static const Color successGreen = Color(0xFF20E6B8);
  static const Color warningOrange = Color(0xFFFF6B35);
  static const Color backgroundGray = Color(0xFFF5F5F5);
  static const Color background = Colors.white;
  static const Color cardWhite = Colors.white;
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Color(0xFF757575);
  
  // Paleta alternativa para splash screen (sem verde)
  static const Color modernBlue = Color(0xFF6366F1);      // Azul elegante
  static const Color modernViolet = Color(0xFF8B5CF6);    // Violeta moderno
  static const Color lightLavender = Color(0xFFF8F4FF);   // Rosa claro elegante
  
  // Gradientes (para futuras implementações)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, Color(0xFF9C4CCC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Gradiente moderno para splash (sem verde)
  static const LinearGradient modernSplashGradient = LinearGradient(
    colors: [primaryPurple, modernBlue, modernViolet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
