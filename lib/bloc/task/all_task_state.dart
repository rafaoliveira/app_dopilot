import 'package:app_dopilot/data/model/task.dart';
import 'package:equatable/equatable.dart';

/// Estados do AllTaskCubit
abstract class AllTaskState extends Equatable {
  const AllTaskState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class AllTaskInitial extends AllTaskState {}

/// Estado de carregamento inicial
class AllTaskLoading extends AllTaskState {}

/// Estado de carregamento de mais itens (paginação)
class AllTaskLoadingMore extends AllTaskState {
  final List<Task> currentTasks;

  const AllTaskLoadingMore(this.currentTasks);

  @override
  List<Object?> get props => [currentTasks];
}

/// Estado de sucesso com lista de tarefas
class AllTaskLoaded extends AllTaskState {
  final List<Task> tasks;
  final String? searchQuery;
  final bool hasMoreTasks;
  final int currentPage;
  final int totalTasks;
  final DateTime loadedAt;

  const AllTaskLoaded({
    required this.tasks,
    this.searchQuery,
    required this.hasMoreTasks,
    required this.currentPage,
    required this.totalTasks,
    required this.loadedAt,
  });

  @override
  List<Object?> get props => [
    tasks,
    searchQuery,
    hasMoreTasks,
    currentPage,
    totalTasks,
    loadedAt
  ];
}

/// Estado de sucesso de tarefa deletada
class AllTaskDeleted extends AllTaskState {}

/// Estado de erro
class AllTaskError extends AllTaskState {
  final String message;

  const AllTaskError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
