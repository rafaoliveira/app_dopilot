import 'package:flutter/material.dart';
import '../../../widgets/app_card.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';

/// Widget individual para item de tarefa
class TaskItem extends StatelessWidget {
  final String title;
  final String time;
  final bool isCompleted;
  final VoidCallback? onToggle;

  const TaskItem({
    super.key,
    required this.title,
    required this.time,
    required this.isCompleted,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onToggle,
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
                    title,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      decoration: isCompleted
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
                        time,
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
                  color: isCompleted
                      ? AppColors.successGreen
                      : Colors.transparent,
                  border: Border.all(
                    color: isCompleted
                        ? AppColors.successGreen
                        : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: isCompleted
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
