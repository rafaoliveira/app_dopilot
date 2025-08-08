/// Enum para prioridade da tarefa
enum TaskPriority {
  alta(3, 'Alta', 'Alta prioridade'),
  media(2, 'Média', 'Prioridade média'),
  baixa(1, 'Baixa', 'Baixa prioridade');

  const TaskPriority(this.apiValue, this.label, this.description);

  /// Valor usado na API
  final int apiValue;
  final String label;
  final String description;

  /// Retorna a prioridade correspondente ao apiValue
  static TaskPriority fromApiValue(int apiValue) {
    return TaskPriority.values.firstWhere(
          (priority) => priority.apiValue == apiValue,
      orElse: () => throw ArgumentError('Prioridade não encontrada: $apiValue'),
    );
  }

  /// Retorna a prioridade correspondente ao apiValue ou null se não encontrar
  static TaskPriority? fromApiValueOrNull(int apiValue) {
    try {
      return fromApiValue(apiValue);
    } catch (e) {
      return null;
    }
  }

}
