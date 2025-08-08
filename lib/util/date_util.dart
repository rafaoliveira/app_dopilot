import 'package:flutter/material.dart';

/// Classe utilitária para formatação de data e hora
class DateUtil {
  DateUtil._(); // Construtor privado para prevenir instanciação

  /// Formata um TimeOfDay para string no padrão HH:mm
  ///
  /// Exemplo:
  /// - TimeOfDay(hour: 9, minute: 5) -> "09:05"
  /// - TimeOfDay(hour: 14, minute: 30) -> "14:30"
  static String formatTimeOfDay(TimeOfDay time) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Formata um DateTime para string no padrão dd/MM/yyyy
  ///
  /// Exemplo:
  /// - DateTime(2025, 8, 8) -> "08/08/2025"
  /// - DateTime(2025, 12, 25) -> "25/12/2025"
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
