import 'package:app_dopilot/bloc/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../util/colors.dart';

import 'dart:math' as math;

/// Splash Screen moderna e atraente do app DoPilot
///
/// Apresenta o logo do app com animações sofisticadas:
/// - Gradiente animado de fundo
/// - Logo com animação de escala e brilho
/// - Partículas flutuantes ao fundo
/// - Loading circular moderno com pulse
/// - Texto com efeito typewriter
/// - Transições suaves e elegantes
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late AnimationController _textController;
  late AnimationController _particlesController;
  late AnimationController _gradientController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _particlesAnimation;
  late Animation<double> _gradientAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Controlador para fade in geral
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Controlador para scale do logo
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Controlador para pulse do loading
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Controlador para fade in do texto
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Controlador para partículas flutuantes
    _particlesController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    // Controlador para gradiente animado
    _gradientController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Animação de fade in suave
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Animação de scale com bounce elegante
    _scaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Animação de pulse contínuo
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Animação de fade in do texto
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    // Animação para partículas
    _particlesAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particlesController,
      curve: Curves.linear,
    ));

    // Animação para gradiente
    _gradientAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _gradientController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() async {
    // Inicia todas as animações em sequência
    _fadeController.forward();
    _gradientController.repeat(reverse: true);
    _particlesController.repeat();

    // Aguarda 200ms e inicia scale do logo
    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();

    // Aguarda 600ms e inicia pulse do loading
    await Future.delayed(const Duration(milliseconds: 600));
    _pulseController.repeat(reverse: true);

    // Aguarda 400ms e inicia fade in do texto
    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();

    // Aguarda finalizar + 1.5s e navega para home
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    // Verificar estado de autenticação antes de navegar
    final authCubit = context.read<AuthCubit>();

    if (authCubit.isLoggedIn) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    _textController.dispose();
    _particlesController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _fadeAnimation,
          _scaleAnimation,
          _pulseAnimation,
          _textFadeAnimation,
          _particlesAnimation,
          _gradientAnimation,
        ]),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  // Roxo principal do app com transparência animada
                  AppColors.primaryPurple.withValues(
                    alpha: 0.15 + (_gradientAnimation.value * 0.08),
                  ),
                  // Rosa claro elegante
                  AppColors.lightLavender,
                  // Azul suave para contraste
                  AppColors.modernBlue.withValues(
                    alpha: 0.08 + (_gradientAnimation.value * 0.05),
                  ),
                ],
                stops: [
                  0.0,
                  0.55 + (_gradientAnimation.value * 0.25),
                  1.0,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Partículas flutuantes ao fundo
                ..._buildFloatingParticles(),

                // Conteúdo principal
                Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo com brilho e sombra animada
                        _buildAnimatedLogo(),

                        const SizedBox(height: 40),

                        // Nome do app com efeito
                        _buildAppTitle(),

                        const SizedBox(height: 8),

                        // Subtitle
                        _buildSubtitle(),

                        const SizedBox(height: 80),

                        // Loading moderno
                        _buildModernLoading(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return Transform.scale(
      scale: _scaleAnimation.value,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withValues(
                alpha: 0.2 * _scaleAnimation.value,
              ),
              spreadRadius: 5,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.white.withValues(
                alpha: 0.8 * _scaleAnimation.value,
              ),
              spreadRadius: -5,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
          gradient: RadialGradient(
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SvgPicture.asset(
            'assets/images/logo.svg',
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }

  Widget _buildAppTitle() {
    return FadeTransition(
      opacity: _textFadeAnimation,
      child: ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            colors: [
              AppColors.primaryPurple,
              AppColors.modernBlue, // Azul elegante
              AppColors.modernViolet, // Violeta moderno
            ],
            stops: [
              0.0,
              0.5 + (_gradientAnimation.value * 0.3),
              1.0,
            ],
          ).createShader(bounds);
        },
        child: Text(
          'DoPilot',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontSize: 36,
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return FadeTransition(
      opacity: _textFadeAnimation,
      child: Text(
        'Pilote suas tarefas com estilo',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.grey[600],
          letterSpacing: 0.8,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildModernLoading() {
    return FadeTransition(
      opacity: _textFadeAnimation,
      child: Column(
        children: [
          // Loading circular com pulse
          Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryPurple,
                    AppColors.modernBlue, // Azul elegante
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withValues(alpha: 0.3),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Texto de carregamento
          Text(
            'Preparando seu piloto...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingParticles() {
    return List.generate(6, (index) {
      final delay = index * 0.5;
      final size = 4.0 + (index % 3) * 2.0;
      final opacity = 0.1 + (index % 4) * 0.05;

      return Positioned(
        left: 50.0 + (index * 60.0) % 300,
        top: 100.0 + (index * 80.0) % 400,
        child: Transform.translate(
          offset: Offset(
            math.sin(_particlesAnimation.value * 2 * math.pi + delay) * 20,
            math.cos(_particlesAnimation.value * 2 * math.pi + delay) * 15,
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (index.isEven ? AppColors.primaryPurple : AppColors.modernViolet) // Violeta moderno
                    .withValues(alpha: opacity),
              ),
            ),
          ),
        ),
      );
    });
  }
}
