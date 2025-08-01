import 'package:equatable/equatable.dart';

import '../../data/model/task_data.dart';

/// Estados do DailyTasksCubit
abstract class DailyTasksState extends Equatable {
  const DailyTasksState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class DailyTasksInitial extends DailyTasksState {}

/// Estado de carregamento
class DailyTasksLoading extends DailyTasksState {}

/// Estado de sucesso com lista de tarefas
class DailyTasksLoaded extends DailyTasksState {
  final List<TaskData> tasks;
  final DateTime loadedAt;

  const DailyTasksLoaded({
    required this.tasks,
    required this.loadedAt,
  });

  @override
  List<Object?> get props => [tasks, loadedAt];
}

/// Estado durante atualização de status de tarefa
class DailyTasksUpdating extends DailyTasksState {
  final List<TaskData> tasks;
  final int taskId;
  final bool newStatus;

  const DailyTasksUpdating({
    required this.tasks,
    required this.taskId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [tasks, taskId, newStatus];
}

/// Estado após atualização bem-sucedida de status
class DailyTasksUpdated extends DailyTasksState {
  final List<TaskData> tasks;
  final TaskData updatedTask;
  final TaskData previousTask; // Para desfazer a ação

  const DailyTasksUpdated({
    required this.tasks,
    required this.updatedTask,
    required this.previousTask,
  });

  @override
  List<Object?> get props => [tasks, updatedTask, previousTask];
}

/// Estado de erro
class DailyTasksError extends DailyTasksState {
  final String message;
  final List<TaskData>? tasks; // Manter tarefas se disponíveis

  const DailyTasksError({
    required this.message,
    this.tasks,
  });

  @override
  List<Object?> get props => [message, tasks];
}
