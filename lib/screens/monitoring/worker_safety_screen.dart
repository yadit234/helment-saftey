import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/monitoring_provider.dart';
import '../../providers/worker_provider.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/empty_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';

class WorkerSafetyScreen extends StatelessWidget {
  const WorkerSafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final monitoringProvider = Provider.of<MonitoringProvider>(context);
    final workerProvider = Provider.of<WorkerProvider>(context);
    final events = monitoringProvider.events;

    return Scaffold(
      appBar: AppBar(title: const Text('Worker Safety & Fall Monitoring')),
      body: SafeArea(
        child: Column(
          children: [
            // Top Summary Bar
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Safety Event Timeline',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Recorded fall detection and safety alerts',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.criticalRed,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onPressed: () {
                      final workers = workerProvider.workers;
                      final worker = workers.isNotEmpty ? workers.first : null;
                      if (worker != null) {
                        monitoringProvider.triggerFallDetection(
                          worker.id,
                          worker.fullName,
                        );
                        workerProvider.updateWorkerSafetyStatus(
                          worker.id,
                          'Fall Detected',
                        );
                      }
                    },
                    icon: const Icon(Icons.accessibility_new, size: 18),
                    label: const Text(
                      'Test Fall',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Safety Events List
            Expanded(
              child: events.isEmpty
                  ? const EmptyState(
                      title: 'No Safety Events Logged',
                      message: 'Simulated fall detection or safety alerts will appear here.',
                      icon: Icons.security,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.notifications_active,
                                          color: AppColors.warningAmber,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          event.eventType,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    StatusBadge(status: event.severity),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  event.description,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${DateFormatter.formatTimeAgo(event.timestamp)} • ${event.dataSource}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                    if (!event.isResolved)
                                      TextButton(
                                        onPressed: () {
                                          monitoringProvider.resolveEvent(
                                            event.id,
                                            'Acknowledged by Safety Inspector',
                                          );
                                        },
                                        child: const Text(
                                          'Resolve Event',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      )
                                    else
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.check,
                                            size: 14,
                                            color: AppColors.successGreen,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Resolved',
                                            style: TextStyle(
                                              fontSize: 11,
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
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
