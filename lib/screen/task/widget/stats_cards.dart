import 'package:app_dopilot/widget/app_card.dart';
import 'package:flutter/material.dart';
import '../../../util/colors.dart';
import '../../../util/constants.dart';

/// Widget que contém os três cards de estatísticas
class StatsCards extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;

  const StatsCards({
    super.key,
    this.totalTasks = 24,
    this.completedTasks = 18,
    this.pendingTasks = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            totalTasks.toString(),
            'Total',
            AppColors.primaryPurple,
          ),
        ),
        const SizedBox(width: AppConstants.paddingMedium),
        Expanded(
          child: _buildStatCard(
            completedTasks.toString(),
            'Concluídas',
            AppColors.successGreen,
          ),
        ),
        const SizedBox(width: AppConstants.paddingMedium),
        Expanded(
          child: _buildStatCard(
            pendingTasks.toString(),
            'Pendentes',
            AppColors.warningOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String number, String label, Color color) {
    return AppCard(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: AppConstants.fontSizeXXLarge,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            label,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
