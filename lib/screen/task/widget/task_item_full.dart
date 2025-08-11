import 'package:app_dopilot/data/enum/task_status.dart';
import 'package:app_dopilot/util/date_util.dart';
import 'package:flutter/material.dart';
import '../../../data/model/task.dart';
import '../../../util/colors.dart';
import '../../../util/constants.dart';

/// Widget para exibir uma tarefa completa na lista de todas as tarefas
class TaskItemFull extends StatelessWidget {
  final Task task;
  final bool isUpdating;
  final VoidCallback? onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskItemFull({
    super.key,
    required this.task,
    this.isUpdating = false,
    this.onToggle,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Card(
        color: AppColors.background,
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCheckbox(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle(context),
                          if (task.description?.isNotEmpty == true) ...[
                            const SizedBox(height: 6),
                            _buildDescription(),
                          ],
                          const SizedBox(height: 8),
                          _buildTimeAndStatus(),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: task.status != TaskStatus.completed,
                      child: _buildActionMenu(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return GestureDetector(
      onTap: isUpdating ? null : onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: task.isCompleted ? AppColors.successGreen : Colors.transparent,
          border: Border.all(
            color: task.isCompleted
                ? AppColors.successGreen
                : Colors.grey.shade400,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: task.isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : isUpdating
            ? const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryPurple,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      task.title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: task.isCompleted ? Colors.grey : AppColors.textPrimary,
        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      task.description!,
      style: TextStyle(
        fontSize: 14,
        color: task.isCompleted ? Colors.grey.shade400 : Colors.grey.shade600,
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTimeAndStatus() {
    return Row(
      children: [
        Icon(Icons.schedule, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          DateUtil.formatTimeOfDay(task.time),
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: task.isCompleted
                ? AppColors.successGreen.withValues(alpha: 0.1)
                : AppColors.warningOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            task.status!.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: task.isCompleted
                  ? AppColors.successGreen
                  : AppColors.warningOrange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      color: AppColors.background,
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18),
              SizedBox(width: 8),
              Text('Editar'),
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
      child: Icon(Icons.more_vert, color: Colors.grey.shade600),
    );
  }
}
