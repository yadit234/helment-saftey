import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/worker_provider.dart';
import '../../providers/monitoring_provider.dart';
import '../../widgets/status_badge.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import 'add_edit_worker_screen.dart';

class WorkerDetailScreen extends StatelessWidget {
  final String workerId;

  const WorkerDetailScreen({super.key, required this.workerId});

  @override
  Widget build(BuildContext context) {
    final workerProvider = Provider.of<WorkerProvider>(context);
    final monitoringProvider = Provider.of<MonitoringProvider>(context);

    final workerList = workerProvider.workers
        .where((w) => w.id == workerId)
        .toList();
    if (workerList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Worker Detail')),
        body: const Center(child: Text('Worker not found.')),
      );
    }

    final worker = workerList.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(worker.fullName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditWorkerScreen(worker: worker),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Worker'),
                  content: Text(
                    'Are you sure you want to delete worker ${worker.fullName}?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.criticalRed,
                      ),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await workerProvider.deleteWorker(worker.id);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Card Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.accentMint,
                      child: Text(
                        worker.fullName.isNotEmpty ? worker.fullName[0] : 'W',
                        style: const TextStyle(
                          fontSize: 32,
                          color: AppColors.primaryDarkGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      worker.fullName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${worker.workerCode} • ${worker.role}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StatusBadge(status: worker.safetyStatus),
                        const SizedBox(width: 10),
                        StatusBadge(
                          status: worker.isCheckedIn ? 'On Duty' : 'Off Duty',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Worker Info Sections
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Employment Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _buildInfoRow('Department', worker.department),
                    _buildInfoRow('Assigned Worksite', worker.worksiteName),
                    _buildInfoRow('Shift Schedule', worker.shift),
                    _buildInfoRow(
                      'Registration Date',
                      DateFormatter.formatShortDate(worker.registrationDate),
                    ),
                    if (worker.lastCheckIn != null)
                      _buildInfoRow(
                        'Last Check-In',
                        DateFormatter.formatFullDateTime(worker.lastCheckIn!),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Contact Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _buildInfoRow('Phone Number', worker.contactNumber),
                    _buildInfoRow(
                      'Emergency Contact Name',
                      worker.emergencyContactName,
                    ),
                    _buildInfoRow(
                      'Emergency Contact Phone',
                      worker.emergencyContactPhone,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Actions & Simulation Test Triggers
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Worker Safety Actions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.warningAmber,
                            ),
                            onPressed: () {
                              monitoringProvider.triggerFallDetection(
                                worker.id,
                                worker.fullName,
                              );
                              workerProvider.updateWorkerSafetyStatus(
                                worker.id,
                                'Fall Detected',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Simulated Fall Event created for ${worker.fullName}',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.accessibility_new,
                              color: Colors.white,
                            ),
                            label: const Text('Simulate Fall Event'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              workerProvider.toggleCheckIn(worker.id);
                            },
                            icon: Icon(
                              worker.isCheckedIn ? Icons.logout : Icons.login,
                            ),
                            label: Text(
                              worker.isCheckedIn
                                  ? 'Check Out Worker'
                                  : 'Check In Worker',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
