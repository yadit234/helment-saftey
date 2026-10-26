import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;

  const StatusBadge({super.key, required this.status, this.fontSize = 11});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case 'operational':
      case 'normal':
      case 'good':
      case 'on duty':
      case 'active':
        bg = AppColors.successBackground;
        fg = AppColors.successGreen;
        break;
      case 'warning':
      case 'due soon':
      case 'maintenance required':
        bg = AppColors.warningBackground;
        fg = AppColors.warningAmber;
        break;
      case 'critical':
      case 'overdue':
      case 'out of service':
      case 'fall detected':
        bg = AppColors.criticalBackground;
        fg = AppColors.criticalRed;
        break;
      default:
        bg = AppColors.infoBackground;
        fg = AppColors.infoBlue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: fg,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
