/// Enum para status das tarefas conforme API DOPilot
enum TaskStatus {
  pending('PENDING', 'Pendente'),
  inProgress('IN_PROGRESS', 'Em Progresso'),
  completed('COMPLETED', 'Concluída'),
  cancelled('CANCELLED', 'Cancelada');

  const TaskStatus(this.apiValue, this.displayName);

  /// Valor usado na API
  final String apiValue;
  
  /// Nome para exibição
  final String displayName;

  /// Converte string da API para TaskStatus
  static TaskStatus fromApiValue(String apiValue) {
    return TaskStatus.values.firstWhere(
      (status) => status.apiValue == apiValue,
      orElse: () => TaskStatus.pending,
    );
  }

  /// Verifica se a tarefa está concluída
  bool get isCompleted => this == TaskStatus.completed;

  /// Verifica se a tarefa está pendente
  bool get isPending => this == TaskStatus.pending;

  /// Verifica se a tarefa está em progresso
  bool get isInProgress => this == TaskStatus.inProgress;

  /// Verifica se a tarefa foi cancelada
  bool get isCancelled => this == TaskStatus.cancelled;

  /// Verifica se a tarefa está ativa (não cancelada nem concluída)
  bool get isActive => this == TaskStatus.pending || this == TaskStatus.inProgress;
}
