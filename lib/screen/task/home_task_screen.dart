import 'package:app_dopilot/bloc/task/daily_task_cubit.dart';
import 'package:app_dopilot/bloc/task/daily_task_state.dart';
import 'package:app_dopilot/data/enum/task_status.dart';
import 'package:app_dopilot/screen/task/widget/stats_cards.dart';
import 'package:app_dopilot/screen/task/widget/tasks_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/task.dart';

class HomeTaskScreen extends StatefulWidget {
  final Function(HomeTaskController) onSeeAllCallback;

  const HomeTaskScreen({super.key, required this.onSeeAllCallback});

  @override
  State<HomeTaskScreen> createState() => _HomeTaskScreenState();
}

class _HomeTaskScreenState extends State<HomeTaskScreen> {
  int totalTasks = 0;
  int completedTasks = 0;
  int pendingTasks = 0;
  bool isLoading = false;
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();

    widget.onSeeAllCallback.call((
      refreshTasks: () {
        _loadTasks();
      },
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Carregar tarefas do dia ao inicializar
      _loadTasks();
    });
  }

  void _loadTasks() {
    context.read<DailyTaskCubit>().loadDailyTasks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DailyTaskCubit, DailyTasksState>(
      listener: (context, state) {
        if (state is DailyTasksLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is DailyTasksError) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red[600],
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is DailyTasksLoaded) {
          setState(() {
            isLoading = false;
            tasks = state.tasks;
            totalTasks = tasks.length;
            completedTasks = tasks.where((task) => task.isCompleted).length;
            pendingTasks = totalTasks - completedTasks;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const SizedBox(height: 32),

            // Stats Cards
            _buildStatsCards(),

            const SizedBox(height: 32),

            // Tarefas do Dia Section
            _buildTasksSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return StatsCards(
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      pendingTasks: pendingTasks,
    );
  }

  Widget _buildTasksSection() {
    return TasksSection(
      isLoading: isLoading,
      tasks: tasks,
      onTaskToggle: (index) {
        final task = tasks[index];
        _completeTask(task);
      },
      onSeeAll: () {
        Navigator.pushNamed(context, '/all-tasks');
      },
    );
  }

  void _completeTask(Task task) {

    final originalStatus = task.status;

    setState(() {
      task.status = TaskStatus.completed;
      task.isCompleted = true;
    });

    // Mostrar SnackBar com ação desfazer
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tarefa "${task.title}" completada',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'DESFAZER',
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  task.status = originalStatus;
                  task.isCompleted = false;
                });
              },
            ),
          ),
        )
        .closed
        .then((reason) {
          // Executar exclusão apenas se foi timeout
          if (reason == SnackBarClosedReason.timeout) {
            context.read<DailyTaskCubit>().toggleTaskCompletion(task.id!);
          }
        });
  }
}

typedef HomeTaskController = ({void Function() refreshTasks});
