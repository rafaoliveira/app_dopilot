import 'package:app_dopilot/data/enum/task_status.dart';
import 'package:flutter/material.dart';

import '../enum/task_category.dart';
import '../enum/task_priority.dart';

/// Modelo de dados para uma tarefa
class Task {
  final int? id; // ID da tarefa (opcional para nova tarefa)
  final String title;
  final String? description;
  late TaskStatus? status;
  final TimeOfDay time;
  final DateTime date;
  bool isCompleted;
  final TaskPriority priority;
  final TaskCategory category;

  Task({
    this.id,
    required this.title,
    this.description,
    this.status,
    required this.time,
    required this.date,
    required this.isCompleted,
    required this.priority,
    required this.category,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    TaskStatus? status,
    TimeOfDay? time,
    DateTime? date,
    bool? isCompleted,
    TaskPriority? priority,
    TaskCategory? category,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      time: time ?? this.time,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, status: $status, time: $time, date: $date, isCompleted: $isCompleted, priority: $priority, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.time == time &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode => Object.hash(id, title, time, isCompleted);
}
