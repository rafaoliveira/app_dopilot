import 'package:app_dopilot/bloc/task/new_task_state.dart';
import 'package:app_dopilot/data/enum/task_category.dart';
import 'package:app_dopilot/data/enum/task_priority.dart';
import 'package:app_dopilot/data/enum/task_status.dart';
import 'package:app_dopilot/data/model/task.dart';
import 'package:app_dopilot/service/task_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit para gerenciamento de tarefas
class NewTaskCubit extends Cubit<NewTaskState> {
  final TaskService _taskService = TaskService();

  NewTaskCubit() : super(NewTaskInitial());

  /// Adiciona nova tarefa
  Future<void> createOrUpdateTask({
    int? id,
    required String title,
    String? description,
    required TimeOfDay time,
    required DateTime date,
    TaskStatus? status,
    required TaskPriority priority,
    required TaskCategory category,
  }) async {

    emit(NewTaskLoading());

    try {
      final task = Task(
        id: id,
        title: title,
        description: description,
        time: time,
        date: date,
        isCompleted: false,
        priority: priority,
        category: category,
        status: status,
      );

      bool success = await _taskService.createOrUpdateTask(task);

      if (success) {
        emit(NewTaskSuccess());
      } else {
        emit(NewTaskError(message: 'Erro ao adicionar tarefa'));
      }


    } catch (e) {
      emit(
        NewTaskError(
          message: 'Erro ao adicionar tarefa',
          details: e.toString(),
        ),
      );
    }
  }
}
