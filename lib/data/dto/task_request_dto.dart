import '../model/task_status.dart';

/// DTO para requisição de criação/atualização de tarefa (TaskRequestDTO)
class TaskRequestDto {
  final String title;
  final String? description;
  final DateTime dueDate;
  final TaskStatus status;
  final int priority; // 1-5 conforme API

  const TaskRequestDto({
    required this.title,
    this.description,
    required this.dueDate,
    required this.status,
    required this.priority,
  });

  /// Converte para Map para envio na API
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status.apiValue,
      'priority': priority,
    };
  }

  /// Cria DTO a partir de Map
  factory TaskRequestDto.fromJson(Map<String, dynamic> json) {
    return TaskRequestDto(
      title: json['title'] ?? '',
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      status: TaskStatus.fromApiValue(json['status'] ?? 'PENDING'),
      priority: json['priority'] ?? 1,
    );
  }

  @override
  String toString() {
    return 'TaskRequestDto(title: $title, description: $description, dueDate: $dueDate, status: $status, priority: $priority)';
  }
}
