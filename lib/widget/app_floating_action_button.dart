import 'package:flutter/material.dart';
import '../../util/colors.dart';

/// FloatingActionButton customizado para o App DoPilot
class AppFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppFloatingActionButton({
    super.key,
    required this.onPressed,
    this.icon = Icons.add,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppColors.primaryPurple,
      foregroundColor: foregroundColor ?? Colors.white,
      tooltip: tooltip,
      shape: const StadiumBorder(),
      child: Icon(icon),
    );
  }
}
