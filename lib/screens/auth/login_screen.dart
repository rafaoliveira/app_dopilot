import 'package:app_dopilot/widgets/app_button.dart';
import 'package:app_dopilot/widgets/app_divider.dart';
import 'package:app_dopilot/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/colors.dart';
import '../../utils/validators.dart';

/// Tela de Login do DoPilot
///
/// Apresenta opções de login com:
/// - Logo e slogan
/// - Campos de email e senha
/// - Link "Esqueceu a senha?"
/// - Botão de login principal
/// - Opções de login social (Google, Facebook)
/// - Link para criar conta
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),

                    // Logo e título
                    _buildHeader(),

                    const SizedBox(height: 60),

                    // Formulário de login
                    _buildLoginForm(),

                    const SizedBox(height: 24),

                    // Link "Esqueceu a senha?"
                    _buildForgotPasswordLink(),

                    const SizedBox(height: 32),

                    // Botão de login
                    _buildLoginButton(isLoading),

                    const SizedBox(height: 32),

                    // Divider "ou continue com"
                    const AppDivider(
                      text: "ou continue com",
                    ),

                    const SizedBox(height: 24),

                    // Botões de login social
                    _buildGoogleLoginButton(),

                    const SizedBox(height: 32),

                    // Link para criar conta
                    _buildSignUpLink(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Center(
          child: SvgPicture.asset(
            'assets/images/logo.svg',
            height: 80,
            width: 80,
          ),
        ),

        const SizedBox(height: 24),

        // Título
        Text(
          'DoPilot',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.bold,
              ),
        ),

        const SizedBox(height: 8),

        // Slogan
        Text(
          'Entre para gerenciar suas tarefas',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        // Campo de email
        AppTextField(
          label: 'E-mail',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          suffixIcon: Icons.email_outlined,
          validator: Validators.validateEmail,
        ),

        const SizedBox(height: 16),

        // Campo de senha
        AppTextField(
          label: 'Senha',
          controller: _passwordController,
          isPassword: true,
          isPasswordVisible: !_isPasswordHidden,
          onPasswordToggle: () {
            setState(() {
              _isPasswordHidden = !_isPasswordHidden;
            });
          },
          validator: Validators.validatePassword,
        ),
      ],
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _handleForgotPassword,
        child: const Text(
          'Esqueceu a senha?',
          style: TextStyle(
            color: AppColors.primaryPurple,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(bool isLoading) {
    return AppButton(
      text: 'Entrar',
      onPressed: _handleLogin,
      isLoading: isLoading,
    );
  }

  Widget _buildGoogleLoginButton() {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: _handleGoogleLogin,
        icon: SvgPicture.asset(
          'assets/images/google.svg',
          height: 24,
          width: 24,
        ),
        label: Text(
          'Continuar com Google',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Não tem uma conta? ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: _handleSignUp,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Criar conta',
            style: TextStyle(
              color: AppColors.primaryPurple,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // Métodos de ação
  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    Navigator.of(context).pushReplacementNamed('/home');

  }

  void _handleForgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite seu e-mail primeiro'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (Validators.validateEmail(email) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite um e-mail válido'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

  }

  void _handleGoogleLogin() async {

  }

  void _handleSignUp() {
    Navigator.pushNamed(context, '/signup');
  }
}
