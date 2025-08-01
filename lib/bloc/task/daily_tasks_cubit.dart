import 'package:app_dopilot/data/model/task_data.dart';
import 'package:app_dopilot/service/task_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'daily_tasks_state.dart';

/// Cubit para gerenciar tarefas do dia atual
///
/// Responsável apenas pela gestão de estado da UI,
/// delegando toda lógica de negócio para o TaskService
class DailyTasksCubit extends Cubit<DailyTasksState> {

  late final TaskService _taskService;

  DailyTasksCubit() : super(DailyTasksInitial()) {
    _taskService = TaskService();
  }

  /// Carregar tarefas do dia atual
  Future<void> loadDailyTasks() async {
    try {
      emit(DailyTasksLoading());

      final today = DateTime.now();
      final tasks = await _taskService.getDailyTasksForHome(today);

      emit(DailyTasksLoaded(
        tasks: tasks,
        loadedAt: DateTime.now(),
      ));
    } catch (e) {
      emit(DailyTasksError(message: 'Erro ao carregar tarefas: $e'));
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
      final updatedTasks = List<TaskData>.from(currentState.tasks);
      updatedTasks[taskIndex] = currentTask.copyWith(isCompleted: newStatus);

      emit(DailyTasksUpdating(
        tasks: updatedTasks,
        taskId: taskId,
        newStatus: newStatus,
      ));

      // Usar o service para atualizar o status
      final updatedTask = await _taskService.toggleTaskCompletion(taskId, newStatus);

      if (updatedTask != null) {
        // Atualizar com dados retornados do service
        final finalTasks = List<TaskData>.from(currentState.tasks);
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

  /// Desfazer última alteração de status
  Future<void> undoLastChange(TaskData previousTask) async {
    final currentState = state;
    if (currentState is! DailyTasksUpdated) return;

    try {
      // Usar o service para reverter na API
      final revertedTask = await _taskService.toggleTaskCompletion(
        previousTask.id!,
        previousTask.isCompleted,
      );

      if (revertedTask != null) {
        // Atualizar lista com estado anterior
        final taskIndex = currentState.tasks.indexWhere((t) => t.id == previousTask.id!);
        if (taskIndex != -1) {
          final revertedTasks = List<TaskData>.from(currentState.tasks);
          revertedTasks[taskIndex] = revertedTask;

          emit(DailyTasksLoaded(
            tasks: revertedTasks,
            loadedAt: DateTime.now(),
          ));
        }
      } else {
        throw Exception('Erro na API ao desfazer alteração');
      }
    } catch (e) {
      emit(DailyTasksError(
        message: 'Erro ao desfazer alteração: $e',
        tasks: currentState.tasks,
      ));
    }
  }

  /// Atualizar lista com nova tarefa criada
  void addTask(TaskData newTask) {
    final currentState = state;
    if (currentState is DailyTasksLoaded) {
      final updatedTasks = List<TaskData>.from(currentState.tasks);
      updatedTasks.add(newTask);
      // A ordenação agora é responsabilidade do service, mas aqui fazemos uma ordenação simples
      updatedTasks.sort((a, b) => a.time.compareTo(b.time));

      emit(DailyTasksLoaded(
        tasks: updatedTasks,
        loadedAt: DateTime.now(),
      ));
    }
  }

  /// Obter estatísticas das tarefas atuais
  ///
  /// Usa o service para calcular as estatísticas
  Map<String, int> getStats() {
    final currentState = state;
    if (currentState is DailyTasksLoaded) {
      return _taskService.calculateStatsFromTasks(currentState.tasks);
    }

    return {'total': 0, 'completed': 0, 'pending': 0};
  }
}