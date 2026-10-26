import 'package:flutter/material.dart';

import '../models/alert.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/date_formatter.dart';
import 'status_badge.dart';

class AlertCard extends StatelessWidget {
  final Alert alert;
  final VoidCallback? onAcknowledge;
  final VoidCallback? onResolve;
  final VoidCallback? onTap;

  const AlertCard({
    super.key,
    required this.alert,
    this.onAcknowledge,
    this.onResolve,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderCol;
    IconData icon;

    switch (alert.severity.toLowerCase()) {
      case 'critical':
        borderCol = AppColors.criticalRed;
        icon = Icons.warning_amber_rounded;
        break;
      case 'high':
        borderCol = AppColors.warningAmber;
        icon = Icons.error_outline_rounded;
        break;
      case 'warning':
        borderCol = AppColors.warningAmber;
        icon = Icons.info_outline_rounded;
        break;
      default:
        borderCol = AppColors.infoBlue;
        icon = Icons.notifications_none_rounded;
    }

    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: borderCol, width: 4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: borderCol, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormatter.formatTimeAgo(alert.timestamp),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(status: alert.severity),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                alert.message,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        alert.worksiteId,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentMint,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          alert.dataSource,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDarkGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!alert.isResolved)
                    Row(
                      children: [
                        if (!alert.isAcknowledged && onAcknowledge != null)
                          TextButton(
                            onPressed: onAcknowledge,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Acknowledge',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        if (onResolve != null)
                          ElevatedButton(
                            onPressed: onResolve,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Resolve',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                      ],
                    )
                  else
                    const Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.successGreen,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Resolved',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.successGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
