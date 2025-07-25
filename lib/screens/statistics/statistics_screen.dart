import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../utils/colors.dart';

/// Tela de Estatísticas do DoPilot
/// 
/// Apresenta dashboard completo com:
/// - Header com avatar e título
/// - Cards de visão geral (Total, Concluídas, Pendentes, Taxa)
/// - Gráfico de pizza (Progresso)
/// - Seção de Insights com dicas personalizadas
/// - Bottom navigation
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with TickerProviderStateMixin {
  late AnimationController _chartAnimationController;
  late Animation<double> _chartAnimation;

  // Dados mockados para demonstração
  final int totalTasks = 24;
  final int completedTasks = 18;
  final int pendingTasks = 6;
  final double completionRate = 75.0;

  @override
  void initState() {
    super.initState();
    _chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _chartAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _chartAnimationController,
      curve: Curves.easeInOut,
    ));
    _chartAnimationController.forward();
  }

  @override
  void dispose() {
    _chartAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildOverviewCards(),
              const SizedBox(height: 32),
              _buildProgressSection(),
              const SizedBox(height: 32),
              _buildInsightsSection(),
              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Estatísticas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.successGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${completionRate.toInt()}% concluído',
              style: const TextStyle(
                color: AppColors.successGreen,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visão Geral',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  title: 'Total',
                  value: totalTasks.toString(),
                  icon: Icons.list_alt,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildOverviewCard(
                  title: 'Concluídas',
                  value: completedTasks.toString(),
                  icon: Icons.check_circle,
                  color: AppColors.successGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  title: 'Pendentes',
                  value: pendingTasks.toString(),
                  icon: Icons.pending,
                  color: AppColors.warningOrange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildOverviewCard(
                  title: 'Taxa',
                  value: '${completionRate.toInt()}%',
                  icon: Icons.trending_up,
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progresso',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: AnimatedBuilder(
                animation: _chartAnimation,
                builder: (context, child) {
                  return SizedBox(
                    width: 200,
                    height: 200,
                    child: CustomPaint(
                      painter: PieChartPainter(
                        completedPercentage: completionRate / 100 * _chartAnimation.value,
                        completedColor: AppColors.successGreen,
                        pendingColor: AppColors.warningOrange,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(
                  color: AppColors.successGreen,
                  label: 'Concluídas',
                  percentage: '${completionRate.toInt()}%',
                ),
                const SizedBox(width: 32),
                _buildLegendItem(
                  color: AppColors.warningOrange,
                  label: 'Pendentes',
                  percentage: '${(100 - completionRate).toInt()}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String percentage,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            Text(
              percentage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInsightsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Insights',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          _buildInsightCard(
            icon: Icons.trending_up,
            iconColor: AppColors.successGreen,
            title: 'Ótima produtividade!',
            description: 'Você completou 75% das suas tarefas esta semana. Continue assim!',
          ),
          const SizedBox(height: 12),
          _buildInsightCard(
            icon: Icons.schedule,
            iconColor: AppColors.warningOrange,
            title: 'Sequência de 5 dias',
            description: 'Você completou tarefas por 5 dias seguidos. Mantenha o ritmo!',
          ),
          const SizedBox(height: 12),
          _buildInsightCard(
            icon: Icons.work,
            iconColor: Colors.blue,
            title: 'Foco no trabalho',
            description: '60% das suas tarefas são relacionadas ao trabalho. Equilibre com atividades pessoais.',
          ),
          const SizedBox(height: 12),
          _buildInsightCard(
            icon: Icons.access_time,
            iconColor: AppColors.primaryPurple,
            title: 'Horário mais produtivo',
            description: 'Você completa mais tarefas entre 9h e 11h. Aprenda sobre cronotipos para otimizar!',
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Painter para o gráfico de pizza
class PieChartPainter extends CustomPainter {
  final double completedPercentage;
  final Color completedColor;
  final Color pendingColor;

  PieChartPainter({
    required this.completedPercentage,
    required this.completedColor,
    required this.pendingColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 20;

    // Pincel para a parte completada
    final completedPaint = Paint()
      ..color = completedColor
      ..style = PaintingStyle.fill;

    // Pincel para a parte pendente
    final pendingPaint = Paint()
      ..color = pendingColor
      ..style = PaintingStyle.fill;

    // Ângulo para a parte completada (em radianos)
    final completedAngle = 2 * math.pi * completedPercentage;

    // Desenhar a parte completada
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Começar do topo
      completedAngle,
      true,
      completedPaint,
    );

    // Desenhar a parte pendente
    if (completedPercentage < 1.0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2 + completedAngle,
        2 * math.pi - completedAngle,
        true,
        pendingPaint,
      );
    }

    // Desenhar círculo interno (para criar efeito de donut)
    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.5, innerPaint);

    // Desenhar percentual no centro
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(completedPercentage * 100).toInt()}%',
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
