import 'package:app_dopilot/data/dto/task_request_dto.dart';
import 'package:app_dopilot/data/enum/task_category.dart';
import 'package:app_dopilot/data/enum/task_priority.dart';
import 'package:flutter/material.dart';

import '../data/dto/task_response_dto.dart';
import '../data/enum/task_status.dart';
import '../data/model/task.dart';
import '../repository/task_repository.dart';

/// Service responsável pela lógica de negócio das tarefas
///
/// Atua como uma camada intermediária entre o Cubit e o Repository,
/// contendo toda a lógica de transformação de dados e regras de negócio
class TaskService {
  late final TaskRepository _taskRepository;

  TaskService() {
    _taskRepository = TaskRepository();
  }

  /// Buscar tarefas do dia atual formatadas para exibição na home
  ///
  /// Retorna uma lista de TaskData já formatada e ordenada
  Future<List<Task>> getDailyTasks() async {
    final DateTime startOfDay = DateTime.now();

    final DateTime endOfDay = DateTime(
      startOfDay.year,
      startOfDay.month,
      startOfDay.day,
      23,
      59,
      59,
    );

    try {
      // Buscar dados do repository
      final tasks = await _taskRepository.getUserTasks(
        startDate: startOfDay,
        endDate: endOfDay,
        size: 50,
        sortBy: 'dueDate',
        direction: 'asc',
      );

      // Converter para TaskData e ordenar
      final taskDataList = tasks.map((dto) => _convertToTaskData(dto)).toList();

      // Ordenar por horário
      taskDataList.sort((a, b) => b.time.compareTo(a.time));

      return taskDataList;
    } catch (e) {
      throw Exception('Erro ao carregar tarefas do dia: $e');
    }
  }

  /// Buscar tarefas do dia atual formatadas para exibição na home
  ///
  /// Retorna uma lista de TaskData já formatada e ordenada
  Future<List<Task>> getTasksByFilter({
    int? page,
    int? size,
    String? sortBy,
    String? direction,
    String? title,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Buscar dados do repository
      final tasks = await _taskRepository.getUserTasks(
        page: page,
        size: size,
        sortBy: sortBy,
        direction: direction,
        title: title,
        status: status,
        startDate: startDate,
        endDate: endDate,
      );

      // Converter para TaskData e ordenar
      final taskDataList = tasks.map((dto) => _convertToTaskData(dto)).toList();

      // Ordenar por horário
      taskDataList.sort((a, b) => a.time.compareTo(b.time));

      return taskDataList;
    } catch (e) {
      throw Exception('Erro ao carregar tarefas do dia: $e');
    }
  }

  Future<bool> createOrUpdateTask(Task task) async {
    try {

      TaskRequestDto _taskDto = _convertTaskToDto(task);

      var response;

      if (task.id == null) {
        response = await _taskRepository.createTask(_taskDto);
      } else {
        response = await _taskRepository.updateTask(task.id!, _taskDto);
      }

      if (response == null) {
        return false;
      }

      return true;

    } catch (e) {
      return false;
    }
  }

  /// Deletar tarefa
  ///
  /// Retorna true se deletada com sucesso, false caso contrário
  Future<bool> deleteTask(int taskId) async {
    try {
      return await _taskRepository.deleteTask(taskId);
    } catch (e) {
      return false;
    }
  }

  /// Alternar status de conclusão de uma tarefa
  ///
  /// Retorna TaskData atualizada ou null em caso de erro
  Future<Task?> toggleTaskCompletion(int taskId) async {
    try {
      final updatedDto = await _taskRepository.toggleTaskCompletion(
        taskId,
        true,
      );

      if (updatedDto != null) {
        return _convertToTaskData(updatedDto);
      }

      return null;
    } catch (e) {
      throw Exception('Erro ao atualizar status da tarefa: $e');
    }
  }

  /// Calcular estatísticas de uma lista de tarefas
  Map<String, int> calculateStatsFromTasks(List<Task> tasks) {
    final completed = tasks.where((t) => t.isCompleted).length;
    final pending = tasks.length - completed;

    return {'total': tasks.length, 'completed': completed, 'pending': pending};
  }

  /// Converter TaskResponseDto para Task
  Task _convertToTaskData(TaskResponseDto dto) {
    return Task(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      status: dto.status,
      time: TimeOfDay(hour: dto.dueDate.hour, minute: dto.dueDate.minute),
      date: dto.dueDate,
      isCompleted: dto.status == TaskStatus.completed,
      priority: TaskPriority.fromApiValue(dto.priority),
      category: TaskCategory.fromApiValue(dto.category),
    );
  }

  /// Converter Task para TaskRequest
  TaskRequestDto _convertTaskToDto(Task task) {
    return TaskRequestDto(
      title: task.title,
      description: task.description,
      status: task.status,
      priority: task.priority.apiValue,
      category: task.category.apiValue,
      dueDate: DateTime(
        task.date.year,
        task.date.month,
        task.date.day,
        task.time.hour,
        task.time.minute,
      ),
    );
  }

}
