import '../model/task_status.dart';

/// DTO para resposta da API (TaskResponseDTO)
class TaskResponseDto {
  final int id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime dueDate;
  final TaskStatus status;
  final int priority;

  const TaskResponseDto({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.completedAt,
    required this.dueDate,
    required this.status,
    required this.priority,
  });

  /// Cria DTO a partir da resposta da API
  factory TaskResponseDto.fromJson(Map<String, dynamic> json) {
    return TaskResponseDto(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      dueDate: DateTime.parse(json['dueDate']),
      status: TaskStatus.fromApiValue(json['status'] ?? 'PENDING'),
      priority: json['priority'] ?? 1,
    );
  }

  /// Converte para Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'status': status.apiValue,
      'priority': priority,
    };
  }

  @override
  String toString() {
    return 'TaskResponseDto(id: $id, title: $title, description: $description, createdAt: $createdAt, completedAt: $completedAt, dueDate: $dueDate, status: $status, priority: $priority)';
  }
}
