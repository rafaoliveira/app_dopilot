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
  final int? maxLines;

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
    this.maxLines = 1,
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
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 16,
        color: enabled ? Colors.black87 : Colors.grey[600],
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: _buildSuffixIcon(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: enabled,
        fillColor: AppColors.background,
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
