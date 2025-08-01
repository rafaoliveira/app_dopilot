import 'task_category.dart';
import 'task_priority.dart';

/// Modelo de dados para uma tarefa
class TaskData {
  final int? id; // ID da tarefa (opcional para nova tarefa)
  final String title;
  final String? description;
  final String time;
  final DateTime? date;
  final bool isCompleted;
  final TaskPriority? priority;
  final TaskCategory? category;

  const TaskData({
    this.id,
    required this.title,
    this.description,
    required this.time,
    this.date,
    required this.isCompleted,
    this.priority,
    this.category,
  });

  TaskData copyWith({
    int? id,
    String? title,
    String? description,
    String? time,
    DateTime? date,
    bool? isCompleted,
    TaskPriority? priority,
    TaskCategory? category,
  }) {
    return TaskData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'TaskData(id: $id, title: $title, description: $description, time: $time, date: $date, isCompleted: $isCompleted, priority: $priority, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskData &&
        other.id == id &&
        other.title == title &&
        other.time == time &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode => Object.hash(id, title, time, isCompleted);
}
