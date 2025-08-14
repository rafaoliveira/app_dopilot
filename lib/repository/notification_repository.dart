import '../util/dio_client.dart';
import '../data/dto/notification_response_dto.dart';
import '../data/dto/notification_update_dto.dart';
import '../data/dto/test_notification_request_dto.dart';
import '../data/dto/unread_count_dto.dart';

/// Serviço para integração com a API de Notificações do DOPilot
///
/// Responsável por gerenciar notificações do usuário
///
/// Endpoints da API:
/// - GET /api/v1/notifications - Listar todas as notificações
/// - GET /api/v1/notification/unread - Listar notificações não lidas
/// - GET /api/v1/notification/unread/count - Contagem de não lidas
/// - PATCH /api/v1/notification/{id} - Marcar como lida
/// - DELETE /api/v1/notification/{id} - Deletar notificação
/// - POST /api/v1/notification/test - Enviar notificação de teste
class NotificationRepository {

  /// Obter todas as notificações do usuário
  Future<List<NotificationResponseDto>?> getAllNotifications() async {
    try {
      final response = await DioClient.get('/api/v1/notifications');

      if (response.isSuccess && response.data != null) {
        final notifications = (response.data as List)
            .map((item) => NotificationResponseDto.fromJson(item))
            .toList();

        return notifications;
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar notificações: $e');
      return null;
    }
  }

  /// Obter notificações não lidas
  Future<List<NotificationResponseDto>?> getUnreadNotifications() async {
    try {
      final response = await DioClient.get('/api/v1/notifications/unread');

      if (response.isSuccess && response.data != null) {
        final notifications = (response.data as List)
            .map((item) => NotificationResponseDto.fromJson(item))
            .toList();

        return notifications;
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar notificações não lidas: $e');
      return null;
    }
  }

  /// Obter contagem de notificações não lidas
  Future<int?> getUnreadCount() async {
    try {
      final response = await DioClient.get('/api/v1/notifications/unread/count');

      if (response.isSuccess && response.data != null) {
        final count = UnreadCountDto.fromJson(response.data);
        return count.unreadCount;
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar contagem de notificações não lidas: $e');
      return null;
    }
  }

  /// Marcar notificação como lida
  Future<NotificationResponseDto?> markAsRead(int id) async {
    try {
      final updateDto = NotificationUpdateDto(read: true);

      final response = await DioClient.patch(
        '/api/v1/notifications/$id',
        data: updateDto.toJson(),
      );

      if (response.isSuccess && response.data != null) {
        final notification = NotificationResponseDto.fromJson(response.data);
        return notification;
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao marcar notificação como lida: $e');
      return null;
    }
  }

  /// Deletar notificação
  Future<bool> deleteNotification(int id) async {
    try {
      final response = await DioClient.delete('/api/v1/notifications/$id');

      if (response.isSuccess) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erro ao deletar notificação: $e');
      return false;
    }
  }

  /// Enviar notificação de teste
  Future<bool> sendTestNotification({
    required String title,
    required String body,
  }) async {
    try {
      final testDto = TestNotificationRequestDto(
        title: title,
        body: body,
      );

      final response = await DioClient.post(
        '/api/v1/notifications/test',
        data: testDto.toJson(),
      );

      if (response.isSuccess) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erro ao enviar notificação de teste: $e');
      return false;
    }
  }
}
