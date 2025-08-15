import 'package:app_dopilot/bloc/task/all_task_state.dart';
import 'package:app_dopilot/service/task_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit para gerenciar todas as tarefas com paginação e pesquisa
class AllTaskCubit extends Cubit<AllTaskState> {
  static const int _pageSize = 20;

  final TaskService _taskService = TaskService();

  // Filtro de status atual
  AllTaskCubit() : super(AllTaskInitial());

  /// Carregar tarefas (página inicial)
  Future<void> loadTasks({String? title, String? status}) async {
    try {
      emit(AllTaskLoading());

      final tasks = await _taskService.getTasksByFilter(
        page: 0,
        // API usa zero-based pagination
        size: _pageSize,
        sortBy: 'createdAt',
        direction: 'desc',
        title: title,
        status: status, // Aplicar filtro de status na API
      );

      // Ordenar por data de criação (mais recentes primeiro)
      tasks.sort((a, b) => b.id!.compareTo(a.id!));

      emit(
        AllTaskLoaded(
          tasks: tasks,
          hasMoreTasks: tasks.length == _pageSize,
          // Se trouxe o limite completo, pode haver mais
          currentPage: 1,
          totalTasks: tasks.length,
          loadedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      emit(AllTaskError(message: 'Erro ao carregar tarefas: $e'));
    }
  }

  /// Deletar uma tarefa
  Future<void> deleteTask(int taskId) async {
    try {
      final success = await _taskService.deleteTask(taskId);

      if (success) {
        emit(AllTaskDeleted());
      }
    } catch (e) {
      emit(AllTaskError(message: 'Erro ao deletar tarefa: $e'));
    }
  }

  /// Alternar status de conclusão de uma tarefa
  Future<void> toggleTaskCompletion(int taskId) async {
    try {
      // Usar o service para atualizar o status
      final updatedTask = await _taskService.toggleTaskCompletion(taskId);

      if (updatedTask != null) {
        emit(AllTaskUpdated());
      } else {
        emit(
          AllTaskError(message: 'Erro ao atualizar tarefa. Tente novamente.'),
        );
      }
    } catch (e) {
      emit(AllTaskError(message: 'Erro ao atualizar tarefa: $e'));
    }
  }
}
