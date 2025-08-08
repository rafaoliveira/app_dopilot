import 'package:app_dopilot/screen/task/widget/task_item.dart';
import 'package:app_dopilot/util/date_util.dart';
import 'package:flutter/material.dart';
import '../../../util/colors.dart';
import '../../../util/constants.dart';
import '../../../data/model/task.dart';

/// Widget da seção "Tarefas do Dia"
class TasksSection extends StatelessWidget {
  final List<Task> tasks;
  final VoidCallback? onSeeAll;
  final Function(int index)? onTaskToggle;

  const TasksSection({
    super.key,
    required this.tasks,
    this.onSeeAll,
    this.onTaskToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tarefas do Dia',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: const Text(
                  'Ver todas',
                  style: TextStyle(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskItem(
                  title: task.title,
                  time: DateUtil.formatTimeOfDay(task.time),
                  isCompleted: task.isCompleted,
                  onToggle: () => onTaskToggle?.call(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
