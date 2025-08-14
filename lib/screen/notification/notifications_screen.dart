import 'package:app_dopilot/bloc/notification/notification_cubit.dart';
import 'package:app_dopilot/bloc/notification/notification_state.dart';
import 'package:app_dopilot/util/date_util.dart';
import 'package:app_dopilot/widget/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/dto/notification_response_dto.dart';
import 'widget/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationResponseDto> notifications = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Carregar todas as notificações ao inicializar
      context.read<NotificationCubit>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, NotificationState>(
      listener: (context, state) {
        if (state is NotificationLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is NotificationLoaded) {
          setState(() {
            notifications = state.notification;
            _isLoading = false;
          });
        } else if (state is NotificationError) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return _buildNotificationsList();
  }

  Widget _buildEmptyState() {
    return EmptyState(
      title: 'Nenhuma notificação',
      subtitle: 'Você está em dia com suas notificações!',
      icon: Icons.notifications_none,
    );
  }

  Widget _buildNotificationsList() {
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
          onMarkAsRead: () {
            context.read<NotificationCubit>().markAsRead(notification.id);
          },
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
              'Recebida em: ${DateUtil.formatDate(notification.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (notification.readAt != null)
              Text(
                'Lida em: ${DateUtil.formatDate(notification.readAt!)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        actions: [
          if (!notification.read)
            TextButton(
              onPressed: () {
                context.read<NotificationCubit>().markAsRead(notification.id);
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
              context.read<NotificationCubit>().delete(notification.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

}
