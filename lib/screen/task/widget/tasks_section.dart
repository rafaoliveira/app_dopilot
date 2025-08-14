import 'package:app_dopilot/screen/task/widget/task_item.dart';
import 'package:app_dopilot/widget/empty_state_widget.dart';
import 'package:flutter/material.dart';

import '../../../data/model/task.dart';
import '../../../util/colors.dart';
import '../../../util/constants.dart';

/// Widget da seção "Tarefas do Dia"
class TasksSection extends StatelessWidget {
  final List<Task> tasks;
  final VoidCallback? onSeeAll;
  final Function(int index)? onTaskToggle;
  final bool? isLoading;

  const TasksSection({
    super.key,
    required this.tasks,
    this.onSeeAll,
    this.onTaskToggle,
    this.isLoading = false,
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
          Visibility(
            visible: isLoading!,
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 48),
              child: CircularProgressIndicator(),
            ),
          ),
          Visibility(
            visible: !isLoading! && tasks.isEmpty,
            child: Center(
              child: EmptyState(
                icon: Icons.task_alt,
                title: 'Nenhuma tarefa encontrada',
                subtitle:
                    'Você ainda não possui tarefas criadas.\nQue tal começar criando uma nova?',
              ),
            ),
          ),
          Visibility(
            visible: !isLoading! && tasks.isNotEmpty,
            child: Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskItem(
                    task: task,
                    onToggle: () => onTaskToggle?.call(index),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
