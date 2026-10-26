import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/worker_provider.dart';
import '../../providers/asset_provider.dart';
import '../../providers/alert_provider.dart';
import '../../providers/monitoring_provider.dart';
import '../../providers/worksite_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final workerProvider = Provider.of<WorkerProvider>(context);
    final assetProvider = Provider.of<AssetProvider>(context);
    final alertProvider = Provider.of<AlertProvider>(context);
    final monitoringProvider = Provider.of<MonitoringProvider>(context);
    final worksiteProvider = Provider.of<WorksiteProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Safety Analytics')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Date Filter Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Report Period Date',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          DateFormatter.formatShortDate(_selectedDate),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2024),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => _selectedDate = picked);
                        }
                      },
                      icon: const Icon(Icons.calendar_today, size: 16),
                      label: const Text('Select Date'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Daily Executive Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daily Executive Safety Summary',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentMint,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'SIMULATED DATA',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDarkGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    _buildReportRow(
                      'Target Worksite',
                      worksiteProvider.selectedWorksite.name,
                    ),
                    _buildReportRow(
                      'Total Registered Workers',
                      '${workerProvider.totalWorkersCount}',
                    ),
                    _buildReportRow(
                      'Workers On Duty Today',
                      '${workerProvider.onDutyWorkersCount}',
                    ),
                    _buildReportRow(
                      'Active Safety Alerts',
                      '${alertProvider.activeAlertsCount}',
                    ),
                    _buildReportRow(
                      'Logged Safety Events',
                      '${monitoringProvider.events.length} Events',
                    ),
                    _buildReportRow(
                      'Operational Equipment',
                      '${assetProvider.operationalAssetsCount} / ${assetProvider.totalAssetsCount} Assets',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Export Actions Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Export & Share Report',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Generate downloadable summary text or CSV formatted report log for compliance auditing.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryDarkGreen,
                            ),
                            onPressed: () {
                              final csvContent =
                                  '''
MineGuard Safety Report - ${DateFormatter.formatShortDate(_selectedDate)}
Worksite,${worksiteProvider.selectedWorksite.name}
Total Workers,${workerProvider.totalWorkersCount}
Workers On Duty,${workerProvider.onDutyWorkersCount}
Active Alerts,${alertProvider.activeAlertsCount}
Operational Assets,${assetProvider.operationalAssetsCount}
Data Source,Simulated Mode Prototype
''';
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Generated CSV Preview'),
                                  content: SingleChildScrollView(
                                    child: SelectableText(csvContent),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.download),
                            label: const Text('Preview CSV Export'),
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

  Widget _buildReportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
