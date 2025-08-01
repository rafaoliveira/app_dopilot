import 'package:flutter/material.dart';
import '../../data/dto/notification_response_dto.dart';
import 'widget/notification_item.dart';

/// Tela de Notificações integrada com API
///
/// Funcionalidades:
/// - Lista de notificações vindas da API
/// - Marcar como lida/não lida
/// - Deletar notificações
/// - Contagem de não lidas
/// - Pull-to-refresh
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationResponseDto> notifications = [
    NotificationResponseDto(
      id: 1,
      title: 'Lembrete de Tarefa',
      message: 'Reunião com a equipe',
      createdAt: DateTime.now(),
      read: false,
    ),
    NotificationResponseDto(
      id: 2,
      title: 'Lembrete de Tarefa',
      message: 'Reunião com a equipe',
      createdAt: DateTime.now(),
      read: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return _buildNotificationsList(notifications);
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Nenhuma notificação',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Você está em dia com suas notificações!',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationResponseDto> notifications) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];

        return NotificationItem(
          notification: notification,
          onTap: () {
            _showNotificationDetails(notification);
          },
          onMarkAsRead: notification.read ? null : () {},
          onDelete: () {
            _confirmDelete(notification);
          },
        );
      },
    );
  }

  void _showNotificationDetails(NotificationResponseDto notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 16),
            if (notification.taskTitle != null) ...[
              Text(
                'Tarefa relacionada:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(notification.taskTitle!),
              const SizedBox(height: 8),
            ],
            Text(
              'Recebida em: ${_formatDate(notification.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (notification.readAt != null)
              Text(
                'Lida em: ${_formatDate(notification.readAt!)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        actions: [
          if (!notification.read)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Marcar como lida'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(NotificationResponseDto notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Notificação'),
        content: Text('Deseja realmente excluir "${notification.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} às ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
