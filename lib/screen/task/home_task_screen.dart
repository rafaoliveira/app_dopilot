import 'package:app_dopilot/bloc/task/daily_task_cubit.dart';
import 'package:app_dopilot/bloc/task/daily_task_state.dart';
import 'package:app_dopilot/screen/task/widget/stats_cards.dart';
import 'package:app_dopilot/screen/task/widget/tasks_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/task.dart';

class HomeTaskScreen extends StatefulWidget {
  const HomeTaskScreen({super.key});

  @override
  State<HomeTaskScreen> createState() => _HomeTaskScreenState();
}

class _HomeTaskScreenState extends State<HomeTaskScreen> {

  @override
  void initState() {
    super.initState();
    // Carregar tarefas do dia ao inicializar
    context.read<DailyTaskCubit>().loadDailyTasks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyTaskCubit, DailyTasksState>(
      listener: (context, state) {
        if (state is DailyTasksUpdated) {
          //_showSnackBarWithUndo(state.updatedTask, state.previousTask);
        } else if (state is DailyTasksError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red[600],
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const SizedBox(height: 32),

              // Stats Cards
              _buildStatsCards(state),

              const SizedBox(height: 32),

              // Tarefas do Dia Section
              _buildTasksSection(state),

            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsCards(DailyTasksState state) {
    int totalTasks = 0;
    int completedTasks = 0;
    int pendingTasks = 0;

    if (state is DailyTasksLoaded ||
        state is DailyTasksUpdating ||
        state is DailyTasksUpdated) {

      final tasks = state is DailyTasksLoaded
          ? state.tasks
          : state is DailyTasksUpdating
          ? state.tasks
          : (state as DailyTasksUpdated).tasks;

      totalTasks = tasks.length;
      completedTasks = tasks.where((task) => task.isCompleted).length;
      pendingTasks = totalTasks - completedTasks;
    }

    return StatsCards(
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      pendingTasks: pendingTasks,
    );
  }

  Widget _buildTasksSection(DailyTasksState state) {
    if (state is DailyTasksLoading) {
      return const TasksSection(
        tasks: [],
        onTaskToggle: null,
        onSeeAll: null,
      );
    }

    if (state is DailyTasksError) {
      return Column(
        children: [
          const Text(
            'Tarefas do Dia',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red[600],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Erro ao carregar tarefas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DailyTaskCubit>().loadDailyTasks();
                    },
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // Estados com tarefas disponíveis
    final tasks = state is DailyTasksLoaded
        ? state.tasks
        : state is DailyTasksUpdating
        ? state.tasks
        : state is DailyTasksUpdated
        ? state.tasks
        : <Task>[];

    final isUpdating = state is DailyTasksUpdating;

    return TasksSection(
      tasks: tasks.take(3).toList(), // Mostrar apenas primeiras 3
      onTaskToggle: isUpdating
          ? null
          : (index) {
        final task = tasks[index];
        if (task.id != null) {
          context.read<DailyTaskCubit>().toggleTaskCompletion(task.id!);
        }
      },
      onSeeAll: () {
        Navigator.pushNamed(context, '/all-tasks');
      },
    );
  }

}
