import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../providers/dashboard_provider.dart';
import '../../providers/monitoring_provider.dart';
import '../../providers/alert_provider.dart';
import '../../providers/worksite_provider.dart';
import '../../services/simulation_service.dart';
import '../../widgets/simulation_banner.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/alert_card.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../workers/add_edit_worker_screen.dart';
import '../assets/add_edit_asset_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboard = Provider.of<DashboardProvider>(context);
    final worksiteProvider = Provider.of<WorksiteProvider>(context);
    final simService = Provider.of<SimulationService>(context);
    final alertProvider = Provider.of<AlertProvider>(context);
    final monitoringProvider = Provider.of<MonitoringProvider>(context);

    final warning = dashboard.overallWarning;
    final now = DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            simService.generateNextReading();
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Current Worksite & Date Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        worksiteProvider.selectedWorksite.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Location: ${worksiteProvider.selectedWorksite.location}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormatter.formatShortDate(now),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        DateFormatter.formatTimeOnly(now),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Simulation Banner
              const SimulationBanner(),
              const SizedBox(height: 14),

              // Overall Site Safety Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: warning
                      ? AppColors.criticalBackground
                      : AppColors.successBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: warning
                        ? AppColors.criticalRed
                        : AppColors.successGreen,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      warning
                          ? Icons.warning_amber_rounded
                          : Icons.verified_user_rounded,
                      color: warning
                          ? AppColors.criticalRed
                          : AppColors.successGreen,
                      size: 36,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dashboard.overallStatusText,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: warning
                                  ? AppColors.criticalRed
                                  : AppColors.successGreen,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            warning
                                ? 'Simulated environmental or worker alert triggers active.'
                                : 'All environmental and worker safety parameters normal.',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Overview Section Title
              const Text(
                'Live Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Environmental Metric Cards Grid
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      title: 'Temperature',
                      value: dashboard.currentTemperature.toStringAsFixed(1),
                      unit: '°C',
                      icon: Icons.thermostat,
                      color: AppColors.chartTemp,
                      warning: dashboard.isHighTemp,
                      subtitle: 'Limit: ${simService.maxTemperature}°C',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MetricCard(
                      title: 'Gas Level',
                      value: '${dashboard.currentGasLevel}',
                      unit: 'ppm',
                      icon: Icons.air,
                      color: AppColors.chartGas,
                      warning: dashboard.isHighGas,
                      subtitle: 'Limit: ${simService.maxGasPpm} ppm',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      title: 'Humidity',
                      value: dashboard.currentHumidity.toStringAsFixed(1),
                      unit: '%',
                      icon: Icons.water_drop,
                      color: AppColors.chartHumidity,
                      subtitle: 'Optimal: 30-70%',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MetricCard(
                      title: 'Vibration',
                      value: dashboard.currentVibration.toStringAsFixed(2),
                      unit: 'g',
                      icon: Icons.vibration,
                      color: AppColors.chartVibration,
                      warning: dashboard.isHighVib,
                      subtitle: 'Limit: ${simService.maxVibration}g',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      title: 'Worker Pulse / Heart Rate',
                      value: '${dashboard.currentHeartRate}',
                      unit: 'BPM',
                      icon: Icons.favorite,
                      color: AppColors.chartHeartRate,
                      warning: dashboard.isHighHeartRate,
                      subtitle: 'Limit: ${simService.maxHeartRate} BPM',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Summary Stat Cards
              const Text(
                'System Summaries',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  _SummaryMiniCard(
                    title: 'Total Workers',
                    value: '${dashboard.totalWorkers}',
                    icon: Icons.people,
                    subtitle: '${dashboard.workersOnDuty} On Duty',
                    color: AppColors.infoBlue,
                  ),
                  const SizedBox(width: 10),
                  _SummaryMiniCard(
                    title: 'Safety Alerts',
                    value: '${dashboard.workersWithAlerts}',
                    icon: Icons.warning,
                    subtitle: 'Worker Alerts',
                    color: dashboard.workersWithAlerts > 0
                        ? AppColors.criticalRed
                        : AppColors.successGreen,
                  ),
                  const SizedBox(width: 10),
                  _SummaryMiniCard(
                    title: 'Total Assets',
                    value: '${dashboard.totalAssets}',
                    icon: Icons.precision_manufacturing,
                    subtitle: '${dashboard.operationalAssets} Operational',
                    color: AppColors.primaryTeal,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      monitoringProvider.activateTestSOS(
                        'w_01',
                        'David K. Lawson',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Test Emergency SOS Activated (Simulated)',
                          ),
                          backgroundColor: AppColors.criticalRed,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.criticalRed,
                    ),
                    icon: const Icon(Icons.sos, color: Colors.white),
                    label: const Text('ACTIVATE TEST SOS'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      simService.triggerHeartRateSpike(
                        'w_01',
                        'David K. Lawson',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Simulated Heart Rate Spike (142 BPM) Triggered',
                          ),
                          backgroundColor: AppColors.criticalRed,
                        ),
                      );
                    },
                    icon: const Icon(Icons.favorite, color: AppColors.criticalRed),
                    label: const Text('Simulate Heart Spike'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      monitoringProvider.triggerFallDetection(
                        'w_01',
                        'David K. Lawson',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Simulated Fall Event Triggered for David K. Lawson',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.accessibility_new),
                    label: const Text('Simulate Fall Event'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddEditWorkerScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add Worker'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddEditAssetScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_to_photos),
                    label: const Text('Add Asset'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Live Trend Chart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Real-Time Environmental Trend',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Updated ${simService.updateIntervalSeconds}s',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Container(
                height: 200,
                padding: const EdgeInsets.only(
                  right: 16,
                  left: 10,
                  top: 16,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: simService.temperatureHistory.isEmpty
                    ? const Center(child: Text('Collecting trend data...'))
                    : LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) =>
                                FlLine(color: Colors.black12, strokeWidth: 1),
                          ),
                          titlesData: FlTitlesData(
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}°C',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textLight,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            // Temp line
                            LineChartBarData(
                              spots: simService.temperatureHistory
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                    return FlSpot(
                                      entry.key.toDouble(),
                                      entry.value.readingValue,
                                    );
                                  })
                                  .toList(),
                              isCurved: true,
                              color: AppColors.chartTemp,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: AppColors.chartTemp.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 24),

              // Recent Alerts List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Safety Alerts',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${alertProvider.activeAlertsCount} Active',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDarkGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (alertProvider.alerts.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No active safety alerts.'),
                  ),
                )
              else
                ...alertProvider.alerts
                    .take(3)
                    .map(
                      (alert) => AlertCard(
                        alert: alert,
                        onAcknowledge: () =>
                            alertProvider.acknowledgeAlert(alert.id),
                        onResolve: () => alertProvider.resolveAlert(
                          alert.id,
                          'Resolved from dashboard',
                        ),
                      ),
                    ),

              const SizedBox(height: 20),

              // Disclaimer Banner
              const ContainerDisclaimer(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryMiniCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String subtitle;
  final Color color;

  const _SummaryMiniCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: AppColors.textLight),
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerDisclaimer extends StatelessWidget {
  const ContainerDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: const Text(
        'Prototype only. Sensor values and events are generated locally in simulation mode. '
        'This software prototype does not contain active physical hardware connections.',
        style: TextStyle(fontSize: 11, color: AppColors.textLight),
        textAlign: TextAlign.center,
      ),
    );
  }
}
