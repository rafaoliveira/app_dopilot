import 'package:app_dopilot/screens/tasks/widgets/stats_cards.dart';
import 'package:app_dopilot/screens/tasks/widgets/tasks_section.dart';
import 'package:flutter/material.dart';

import '../../models/task_data.dart';

class HomeTaskScreen extends StatefulWidget {
  const HomeTaskScreen({super.key});

  @override
  State<HomeTaskScreen> createState() => _HomeTaskScreenState();
}

class _HomeTaskScreenState extends State<HomeTaskScreen> {
  final List<TaskData> _tasks = [
    const TaskData(
      id: 1,
      title: 'Reunião com equipe',
      time: '09:00',
      isCompleted: false,
    ),
    const TaskData(
      id: 2,
      title: 'Revisar relatório mensal',
      time: '14:30',
      isCompleted: true,
    ),
    const TaskData(
      id: 3,
      title: 'Ligar para cliente',
      time: '16:00',
      isCompleted: false,
    ),
    const TaskData(
      id: 4,
      title: 'Comprar ingredientes',
      time: '18:00',
      isCompleted: false,
    ),
    const TaskData(
      id: 5,
      title: 'Comprar ingredientes 2',
      time: '18:00',
      isCompleted: false,
    ),
    const TaskData(
      id: 6,
      title: 'Comprar ingredientes 3',
      time: '18:00',
      isCompleted: false,
    ),
    const TaskData(
      id: 7,
      title: 'Comprar ingredientes 4',
      time: '18:00',
      isCompleted: false,
    ),
  ];

  void _toggleTask(int index) {
    setState(() {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
    });
  }

  void _addTask(String title, String time) {
    setState(() {
      _tasks.add(
        TaskData(
          id: _tasks.length + 1, // Simular ID auto-incrementado
          title: title,
          time: time,
          isCompleted: false,
        ),
      );
    });
  }

  void _showAddTaskModal() {
    Navigator.pushNamed(context, '/new-task').then((result) {
      if (result != null && result is TaskData) {
        _addTask(result.title, result.time);
      }
    });
  }

  int get _completedTasks => _tasks.where((task) => task.isCompleted).length;

  int get _pendingTasks => _tasks.where((task) => !task.isCompleted).length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Header
          const SizedBox(height: 32),

          // Stats Cards
          StatsCards(
            totalTasks: _tasks.length,
            completedTasks: _completedTasks,
            pendingTasks: _pendingTasks,
          ),

          const SizedBox(height: 32),

          // Tarefas do Dia Section
          TasksSection(
            tasks: _tasks,
            onTaskToggle: _toggleTask,
            onSeeAll: () {

            },
          ),

        ],
      ),
    );
  }
}