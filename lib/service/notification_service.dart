import 'package:app_dopilot/data/dto/notification_response_dto.dart';
import 'package:app_dopilot/repository/notification_repository.dart';

class NotificationService {
  late final NotificationRepository _notificationRepository;

  NotificationService() {
    _notificationRepository = NotificationRepository();
  }

  /// Buscar todas as notificações do usuário
  Future<List<NotificationResponseDto>?> getAllNotifications() async {
    try {
      return await _notificationRepository.getAllNotifications();
    } catch (e) {
      print('Erro no service ao buscar notificações: $e');
      return null;
    }
  }

  /// Buscar notificações não lidas
  Future<List<NotificationResponseDto>?> getUnreadNotifications() async {
    try {
      return await _notificationRepository.getUnreadNotifications();
    } catch (e) {
      print('Erro no service ao buscar notificações não lidas: $e');
      return null;
    }
  }

  /// Buscar contagem de notificações não lidas
  Future<int?> getUnreadCount() async {
    try {
      return await _notificationRepository.getUnreadCount();
    } catch (e) {
      print('Erro no service ao buscar contagem de não lidas: $e');
      return null;
    }
  }

  /// Marcar notificação como lida
  Future<bool> markAsRead(int notificationId) async {
    try {
      final result = await _notificationRepository.markAsRead(notificationId);
      return result != null;
    } catch (e) {
      print('Erro no service ao marcar notificação como lida: $e');
      return false;
    }
  }

  /// Deletar notificação
  Future<bool> deleteNotification(int notificationId) async {
    try {
      return await _notificationRepository.deleteNotification(notificationId);
    } catch (e) {
      print('Erro no service ao deletar notificação: $e');
      return false;
    }
  }

  /// Enviar notificação de teste
  Future<bool> sendTestNotification({
    required String title,
    required String body,
  }) async {
    try {
      return await _notificationRepository.sendTestNotification(
        title: title,
        body: body,
      );
    } catch (e) {
      print('Erro no service ao enviar notificação de teste: $e');
      return false;
    }
  }
}
