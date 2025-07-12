import 'package:flutter/material.dart';
import '../utils/colors.dart';

/// Widget customizado para campos de input do DoPilot
/// 
/// Segue o design system da app com bordas arredondadas,
/// cores consistentes e validação integrada
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? suffixIcon;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onPasswordToggle;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.suffixIcon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onPasswordToggle,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword && !isPasswordVisible,
      enabled: enabled,
      validator: validator,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 16,
        color: enabled ? Colors.black87 : Colors.grey[600],
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 16,
        ),
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 16,
        ),
        suffixIcon: _buildSuffixIcon(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: !enabled,
        fillColor: enabled ? null : Colors.grey[50],
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (isPassword) {
      return IconButton(
        icon: Icon(
          isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: Colors.grey[600],
        ),
        onPressed: onPasswordToggle,
      );
    }

    if (suffixIcon != null) {
      return Icon(
        suffixIcon,
        color: Colors.grey[600],
      );
    }

    return null;
  }
}
