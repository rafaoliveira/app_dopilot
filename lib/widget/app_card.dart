import 'package:flutter/material.dart';
import '../../util/colors.dart';
import '../../util/constants.dart';

/// Widget de card reutilizável seguindo o padrão do DoPilot
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsets? margin;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: color ?? AppColors.cardWhite,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppConstants.borderRadiusLarge,
        ),
        boxShadow: boxShadow ?? AppConstants.cardShadow,
      ),
      child: child,
    );
  }
}
