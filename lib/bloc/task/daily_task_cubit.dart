import 'package:app_dopilot/data/model/task.dart';
import 'package:app_dopilot/service/task_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'daily_task_state.dart';

/// Cubit para gerenciar tarefas do dia atual
///
/// Responsável apenas pela gestão de estado da UI,
/// delegando toda lógica de negócio para o TaskService
class DailyTaskCubit extends Cubit<DailyTasksState> {

  late final TaskService _taskService;

  DailyTaskCubit() : super(DailyTasksInitial()) {
    _taskService = TaskService();
  }

  /// Carregar tarefas do dia atual
  Future<void> loadDailyTasks() async {
    try {
      emit(DailyTasksLoading());

      final tasks = await _taskService.getDailyTasks();

      emit(DailyTasksLoaded(
        tasks: tasks,
        loadedAt: DateTime.now(),
      ));
    } catch (e) {
      emit(DailyTasksError(message: 'Erro ao carregar tarefas'));
    }
  }

  /// Alternar status de conclusão de uma tarefa
  Future<void> toggleTaskCompletion(int taskId) async {
    final currentState = state;
    if (currentState is! DailyTasksLoaded) return;

    try {
      // Encontrar a tarefa
      final taskIndex = currentState.tasks.indexWhere((t) => t.id == taskId);
      if (taskIndex == -1) return;

      final currentTask = currentState.tasks[taskIndex];
      final newStatus = !currentTask.isCompleted;

      // Emit estado de carregamento com preview da mudança
      final updatedTasks = List<Task>.from(currentState.tasks);
      updatedTasks[taskIndex] = currentTask.copyWith(isCompleted: newStatus);

      emit(DailyTasksUpdating(
        tasks: updatedTasks,
        taskId: taskId,
        newStatus: newStatus,
      ));

      // Usar o service para atualizar o status
      final updatedTask = await _taskService.toggleTaskCompletion(taskId);

      if (updatedTask != null) {
        // Atualizar com dados retornados do service
        final finalTasks = List<Task>.from(currentState.tasks);
        finalTasks[taskIndex] = updatedTask;

        emit(DailyTasksUpdated(
          tasks: finalTasks,
          updatedTask: updatedTask,
          previousTask: currentTask,
        ));
      } else {
        emit(DailyTasksError(
          message: 'Erro ao atualizar tarefa. Tente novamente.',
          tasks: currentState.tasks,
        ));
      }
    } catch (e) {
      emit(DailyTasksError(
        message: 'Erro ao atualizar tarefa: $e',
        tasks: currentState.tasks,
      ));
    }
  }

}