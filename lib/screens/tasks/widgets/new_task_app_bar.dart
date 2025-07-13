import 'package:flutter/material.dart';
import '../../../models/task_data.dart';
import '../../../utils/colors.dart';

/// AppBar customizado para a tela nova tarefa
class NewTaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NewTaskAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.primaryPurple),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.primaryPurple,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
