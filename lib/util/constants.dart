import 'package:flutter/material.dart';

/// Constantes de estilo e medidas do DoPilot
class AppConstants {
  // Padding e margens
  static const double paddingLarge = 20.0;
  static const double paddingMedium = 16.0;
  static const double paddingSmall = 8.0;
  static const double paddingXSmall = 4.0;
  
  // Border radius
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusSmall = 8.0;
  
  // Elevações
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  
  // Tamanhos de ícones
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  
  // Tamanhos de fontes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 24.0;
  static const double fontSizeXXLarge = 32.0;
  
  // Sombra padrão para cards
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.grey.withValues(alpha: 0.1),
      spreadRadius: 1,
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}
