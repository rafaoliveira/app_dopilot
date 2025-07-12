import 'package:app_dopilot/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 40),
                  _buildAppTitle(),
                  const SizedBox(height: 8),
                  _buildSubtitle(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SvgPicture.asset(
        'assets/images/logo.svg',
        width: 100,
        height: 100,
      ),
    );
  }

  Widget _buildAppTitle() {
    return Text(
      'DoPilot',
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        color: AppColors.primaryPurple,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
        fontSize: 36,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Pilote suas tarefas com estilo',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Colors.grey[600],
        letterSpacing: 0.8,
        fontSize: 16,
      ),
    );
  }
}
