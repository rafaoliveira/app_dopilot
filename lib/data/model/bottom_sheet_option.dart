import 'package:flutter/material.dart';

/// Classe para representar uma opção no bottom sheet
class BottomSheetOption<T> {
  final T value;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? color;

  const BottomSheetOption({
    required this.value,
    required this.title,
    this.subtitle,
    this.icon,
    this.color,
  });
}