import 'package:flutter/material.dart';

/// Classe utilitária para validações de formulários
class Validators {
  /// Valida se o email tem formato válido
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu e-mail';
    }

    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
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

  /// Valida título de tarefa
  static String? validateTaskTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite o título da tarefa';
    }

    if (value.trim().length < 3) {
      return 'O título deve ter pelo menos 3 caracteres';
    }

    if (value.trim().length > 100) {
      return 'O título deve ter no máximo 100 caracteres';
    }

    return null;
  }

  /// Valida descrição de tarefa (opcional)
  static String? validateTaskDescription(String? value) {
    // Descrição é opcional, então null ou vazio é válido
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.trim().length > 500) {
      return 'A descrição deve ter no máximo 500 caracteres';
    }

    return null;
  }

  /// Valida data de tarefa
  static String? validateTaskDate(String? value, DateTime? selectedDate) {
    if (value == null || value.isEmpty) {
      return 'Por favor, selecione uma data';
    }

    if (selectedDate == null) {
      return 'Data inválida';
    }

    // Verifica se a data não é no passado (ignora horário)
    final today = DateTime.now();
    final dateOnly = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final todayOnly = DateTime(today.year, today.month, today.day);

    if (dateOnly.isBefore(todayOnly)) {
      return 'A data não pode ser no passado';
    }

    return null;
  }

  /// Valida horário de tarefa (opcional)
  static String? validateTaskTime(String? value, TimeOfDay? selectedTime, DateTime? selectedDate) {
    // Horário é opcional
    if (value == null || value.isEmpty) {
      return null;
    }

    if (selectedTime == null) {
      return 'Horário inválido';
    }

    // Se a data selecionada for hoje, verifica se o horário não é no passado
    if (selectedDate != null) {
      final today = DateTime.now();
      final dateOnly = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final todayOnly = DateTime(today.year, today.month, today.day);

      if (dateOnly.isAtSameMomentAs(todayOnly)) {
        final selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        if (selectedDateTime.isBefore(today)) {
          return 'O horário não pode ser no passado';
        }
      }
    }

    return null;
  }
}
