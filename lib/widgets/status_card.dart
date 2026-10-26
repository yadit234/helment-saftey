import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class StatusCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool active;
  final VoidCallback? onTap;

  const StatusCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.active,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: active ? AppColors.criticalBackground : Colors.white,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: active
              ? AppColors.criticalRed.withOpacity(0.15)
              : AppColors.successBackground,
          child: Icon(
            icon,
            color: active ? AppColors.criticalRed : AppColors.successGreen,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: Icon(
          active ? Icons.warning_rounded : Icons.check_circle_rounded,
          color: active ? AppColors.criticalRed : AppColors.successGreen,
        ),
      ),
    );
  }
}
