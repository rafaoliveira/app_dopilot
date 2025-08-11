import 'package:app_dopilot/data/model/task.dart';
import 'package:app_dopilot/util/date_util.dart';
import 'package:flutter/material.dart';
import '../../../widget/app_card.dart';
import '../../../util/colors.dart';
import '../../../util/constants.dart';

/// Widget individual para item de tarefa
class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback? onToggle;

  const TaskItem({
    super.key,
    required this.task,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onToggle,
      onTap: () {
        Navigator.of(context).pushNamed('/new-task', arguments: {'task': task});
      },
      child: AppCard(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: AppConstants.iconSizeSmall,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppConstants.paddingXSmall),
                      Text(
                        DateUtil.formatTimeOfDay(task.time),
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.isCompleted
                      ? AppColors.successGreen
                      : Colors.transparent,
                  border: Border.all(
                    color: task.isCompleted
                        ? AppColors.successGreen
                        : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: task.isCompleted
                    ? const Icon(
                        Icons.check,
                        size: AppConstants.iconSizeSmall,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
