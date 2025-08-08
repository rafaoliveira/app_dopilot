import 'package:flutter/material.dart';

/// Enum para categoria da tarefa
enum TaskCategory {
  trabalho('TRABALHO','Trabalho', Icons.work, Color(0xFF7B2CBF)),
  pessoal('PESSOAL','Pessoal', Icons.person, Color(0xFF6B7280)),
  saude('SAUDE','Saúde', Icons.favorite, Color(0xFFEF4444)),
  estudos('ESTUDOS','Estudos', Icons.school, Color(0xFF3B82F6));

  const TaskCategory(this.apiValue, this.label, this.icon, this.color);

  /// Valor usado na API
  final String apiValue;
  final String label;
  final IconData icon;
  final Color color;

  /// Retorna a categoria correspondente ao apiValue
  static TaskCategory fromApiValue(String apiValue) {
    return TaskCategory.values.firstWhere(
          (category) => category.apiValue == apiValue,
      orElse: () => throw ArgumentError('Categoria não encontrada: $apiValue'),
    );
  }
}
