/// Enum para prioridade da tarefa
enum TaskPriority {
  alta('Alta', 'Alta prioridade'),
  media('Média', 'Prioridade média'),
  baixa('Baixa', 'Baixa prioridade');

  const TaskPriority(this.label, this.description);
  final String label;
  final String description;
}
