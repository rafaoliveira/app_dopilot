import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

/// Botão customizado seguindo o padrão do DoPilot
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.primaryPurple;
    final effectiveTextColor = textColor ?? Colors.white;

    return SizedBox(
      width: width,
      height: height ?? 48,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: effectiveBackgroundColor, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
              ),
              icon: _buildIcon(effectiveBackgroundColor),
              label: _buildLabel(effectiveBackgroundColor),
            )
          : ElevatedButton.icon(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: effectiveBackgroundColor,
                foregroundColor: effectiveTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
                elevation: AppConstants.elevationLow,
              ),
              icon: _buildIcon(effectiveTextColor),
              label: _buildLabel(effectiveTextColor),
            ),
    );
  }

  Widget _buildIcon(Color color) {
    if (isLoading) {
      return SizedBox(
        width: AppConstants.iconSizeSmall,
        height: AppConstants.iconSizeSmall,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }
    
    if (icon != null) {
      return Icon(icon, size: AppConstants.iconSizeSmall);
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildLabel(Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: AppConstants.fontSizeMedium,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
