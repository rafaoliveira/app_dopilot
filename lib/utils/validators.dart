/// Classe utilitária para validações de formulários
class Validators {
  /// Valida se o email tem formato válido
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu e-mail';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, digite um e-mail válido';
    }

    return null;
  }

  /// Valida se a senha atende aos critérios mínimos
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite sua senha';
    }

    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }

    return null;
  }

  /// Valida se o campo obrigatório não está vazio
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite $fieldName';
    }
    return null;
  }

  /// Valida confirmação de senha
  static String? validatePasswordConfirmation(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Por favor, confirme sua senha';
    }

    if (value != password) {
      return 'As senhas não coincidem';
    }

    return null;
  }

  /// Valida nome (mínimo 2 caracteres)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu nome';
    }

    if (value.trim().length < 2) {
      return 'O nome deve ter pelo menos 2 caracteres';
    }

    return null;
  }

  /// Valida telefone (formato brasileiro básico)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu telefone';
    }

    // Remove caracteres não numéricos
    final cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanPhone.length < 10 || cleanPhone.length > 11) {
      return 'Por favor, digite um telefone válido';
    }

    return null;
  }
}
