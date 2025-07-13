import 'package:flutter/material.dart';

/// Enum para categoria da tarefa
enum TaskCategory {
  trabalho('Trabalho', Icons.work, Color(0xFF7B2CBF)),
  pessoal('Pessoal', Icons.person, Color(0xFF6B7280)),
  saude('Saúde', Icons.favorite, Color(0xFFEF4444)),
  estudos('Estudos', Icons.school, Color(0xFF3B82F6));

  const TaskCategory(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}
