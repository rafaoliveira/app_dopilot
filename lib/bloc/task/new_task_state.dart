import 'package:equatable/equatable.dart';

/// Estados do TaskCubit
abstract class NewTaskState extends Equatable {
  const NewTaskState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class NewTaskInitial extends NewTaskState {}

/// Estado de carregamento
class NewTaskLoading extends NewTaskState {}


/// Estado de erro
class NewTaskError extends NewTaskState {
  final String message;
  final String? details;

  const NewTaskError({
    required this.message,
    this.details,
  });

  @override
  List<Object?> get props => [message, details];
}

/// Estado de sucesso na criação de tarefa
class NewTaskSuccess extends NewTaskState {

}
