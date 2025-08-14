import 'package:app_dopilot/data/dto/notification_response_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/notification_service.dart';
import 'notification_state.dart';

/// Cubit para gerenciar notificações
class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());
  final NotificationService _notificationService = NotificationService();

  /// Carregar todas as notificações e contagem de não lidas
  Future<void> loadNotifications() async {
    try {
      emit(NotificationLoading());

      // Carregar notificações e contagem em paralelo
      final results = await Future.wait([
        _notificationService.getAllNotifications(),
        _notificationService.getUnreadCount(),
      ]);

      final notifications = results[0] as List<NotificationResponseDto>?;
      final unreadCount = results[1] as int?;

      if (notifications != null) {
        // Ordenar por data de criação (mais recentes primeiro)
        notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        emit(
          NotificationLoaded(
            notification: notifications,
            unreadCount: unreadCount ?? 0,
          ),
        );
      } else {
        emit(NotificationError(message: 'Erro ao carregar notificações'));
      }
    } catch (e) {
      emit(NotificationError(message: 'Erro ao carregar notificações: $e'));
    }
  }

  /// Carregar apenas notificações não lidas
  Future<void> loadUnreadNotifications() async {
    try {
      emit(NotificationLoading());

      final notifications = await _notificationService.getUnreadNotifications();

      if (notifications != null) {
        // Ordenar por data de criação (mais recentes primeiro)
        notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        emit(
          NotificationLoaded(
            notification: notifications,
            unreadCount: notifications.length,
          ),
        );
      } else {
        emit(NotificationError(message: 'Erro ao carregar notificações não lidas'));
      }
    } catch (e) {
      emit(NotificationError(message: 'Erro ao carregar notificações: $e'));
    }
  }

  /// Marcar notificação como lida
  Future<void> markAsRead(int notificationId) async {
    try {
      emit(NotificationLoading());

      final updatedNotification = await _notificationService.markAsRead(
        notificationId,
      );

      if (updatedNotification) {
        return loadNotifications();
      } else {
        emit(
          NotificationError(message: 'Erro ao marcar notificação como lida'),
        );
      }
    } catch (e) {
      emit(
        NotificationError(message: 'Erro ao marcar notificação como lida: $e'),
      );
    }
  }

  /// Deletar notificação
  Future<void> delete(int notificationId) async {
    try {
      emit(NotificationLoading());

      final success = await _notificationService.deleteNotification(
        notificationId,
      );

      if (success) {
        return loadNotifications();
      } else {
        emit(NotificationError(message: 'Erro ao deletar a notificação'));
      }
    } catch (e) {
      emit(NotificationError(message: 'Erro ao deletar notificação: $e'));
    }
  }
}
