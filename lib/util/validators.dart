/// Classe utilitária para validações de formulários
class Validators {
  /// Valida se o email tem um formato válido
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Digite um email válido';
    }

    return null;
  }

  /// Valida se a senha atende aos critérios mínimos
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }

    return null;
  }

  /// Valida o título da tarefa
  static String? validateTaskTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Título da tarefa é obrigatório';
    }

    if (value.length < 3) {
      return 'Título deve ter pelo menos 3 caracteres';
    }

    if (value.length > 100) {
      return 'Título deve ter no máximo 100 caracteres';
    }

    return null;
  }

  /// Valida a descrição da tarefa
  static String? validateTaskDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Descrição da tarefa é obrigatória';
    }

    if (value.length < 10) {
      return 'Descrição deve ter pelo menos 10 caracteres';
    }

    if (value.length > 500) {
      return 'Descrição deve ter no máximo 500 caracteres';
    }

    return null;
  }

  /// Valida campos de texto genéricos
  static String? validateRequired(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  /// Valida campos de texto com comprimento mínimo e máximo
  static String? validateLength(
    String? value, {
    int? minLength,
    int? maxLength,
    String fieldName = 'Campo',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }

    if (minLength != null && value.length < minLength) {
      return '$fieldName deve ter pelo menos $minLength caracteres';
    }

    if (maxLength != null && value.length > maxLength) {
      return '$fieldName deve ter no máximo $maxLength caracteres';
    }

    return null;
  }
}
