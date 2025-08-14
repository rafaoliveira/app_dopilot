import 'package:app_dopilot/data/dto/notification_response_dto.dart';
import 'package:equatable/equatable.dart';

/// Estados do NotificationCubit
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class NotificationInitial extends NotificationState {}

/// Estado de carregamento
class NotificationLoading extends NotificationState {}

/// Estado de sucesso com lista de notificações
class NotificationLoaded extends NotificationState {
  final List<NotificationResponseDto> notification;
  final int unreadCount;

  const NotificationLoaded({
    required this.notification,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notification, unreadCount];
}

/// Estado de erro
class NotificationError extends NotificationState {
  final String message;

  const NotificationError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
