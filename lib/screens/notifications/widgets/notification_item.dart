import 'package:flutter/material.dart';
import '../../../utils/colors.dart';
import '../../../models/notification_dto.dart';

/// Tipos de notificação para identificação visual
enum NotificationType {
  reminder,
  taskCompleted,
  taskCreated,
  system,
}

/// Widget para exibir um item de notificação
class NotificationItem extends StatelessWidget {
  final NotificationDto notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onDelete;

  const NotificationItem({
    super.key,
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: notification.read ? Colors.white : Colors.blue.shade50,
              border: notification.read 
                  ? null 
                  : Border.all(color: Colors.blue.shade100, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 4),
                      _buildBody(context),
                      const SizedBox(height: 8),
                      _buildFooter(context),
                    ],
                  ),
                ),
                _buildActionMenu(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    // Determinar tipo baseado no conteúdo da notificação
    NotificationType type = _getNotificationType();
    IconData iconData;
    Color iconColor;

    switch (type) {
      case NotificationType.reminder:
        iconData = Icons.schedule;
        iconColor = AppColors.warningOrange;
        break;
      case NotificationType.taskCompleted:
        iconData = Icons.check_circle;
        iconColor = AppColors.successGreen;
        break;
      case NotificationType.taskCreated:
        iconData = Icons.add_task;
        iconColor = AppColors.primaryPurple;
        break;
      case NotificationType.system:
        iconData = Icons.info;
        iconColor = Colors.blue;
        break;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  NotificationType _getNotificationType() {
    final titleLower = notification.title.toLowerCase();
    final messageLower = notification.message.toLowerCase();
    
    if (titleLower.contains('lembrete') || messageLower.contains('lembrete')) {
      return NotificationType.reminder;
    } else if (titleLower.contains('concluída') || messageLower.contains('concluída')) {
      return NotificationType.taskCompleted;
    } else if (titleLower.contains('criada') || messageLower.contains('criada')) {
      return NotificationType.taskCreated;
    } else {
      return NotificationType.system;
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            notification.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: notification.read ? FontWeight.w500 : FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (!notification.read)
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primaryPurple,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Text(
      notification.message,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Colors.grey.shade600,
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: Colors.grey.shade500,
        ),
        const SizedBox(width: 4),
        Text(
          _formatTime(notification.createdAt),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        if (notification.read)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Lida',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'mark_read':
            onMarkAsRead?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        if (!notification.read)
          const PopupMenuItem(
            value: 'mark_read',
            child: Row(
              children: [
                Icon(Icons.mark_email_read, size: 18),
                SizedBox(width: 8),
                Text('Marcar como lida'),
              ],
            ),
          ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 18, color: Colors.red),
              SizedBox(width: 8),
              Text('Excluir', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      child: Icon(
        Icons.more_vert,
        color: Colors.grey.shade600,
        size: 20,
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Agora';
    } else if (difference.inMinutes < 60) {
      return 'Há ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'Há ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Há ${difference.inDays}d';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
