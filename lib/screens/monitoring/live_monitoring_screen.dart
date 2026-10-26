import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../services/simulation_service.dart';
import '../../providers/worksite_provider.dart';
import '../../widgets/simulation_banner.dart';
import '../../widgets/metric_card.dart';
import '../../core/constants/app_colors.dart';

class LiveMonitoringScreen extends StatelessWidget {
  const LiveMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final simService = Provider.of<SimulationService>(context);
    final worksiteProvider = Provider.of<WorksiteProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Live Environmental Monitoring',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  tooltip: 'Manual Sensor Refresh',
                  icon: const Icon(
                    Icons.refresh,
                    color: AppColors.primaryDarkGreen,
                  ),
                  onPressed: () {
                    simService.generateNextReading();
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            const SimulationBanner(),
            const SizedBox(height: 14),

            // Worksite & Update speed bar
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 18,
                          color: AppColors.primaryDarkGreen,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          worksiteProvider.selectedWorksite.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Rate: ',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: simService.updateIntervalSeconds,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDarkGreen,
                            ),
                            onChanged: (val) {
                              if (val != null) simService.updateInterval(val);
                            },
                            items: const [
                              DropdownMenuItem(value: 1, child: Text('1s')),
                              DropdownMenuItem(value: 2, child: Text('2s')),
                              DropdownMenuItem(value: 3, child: Text('3s')),
                              DropdownMenuItem(value: 5, child: Text('5s')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Live Sensor Gauges / Cards
            Row(
              children: [
                Expanded(
                  child: MetricCard(
                    title: 'Temperature Sensor',
                    value: simService.currentTemperature.readingValue
                        .toStringAsFixed(1),
                    unit: simService.currentTemperature.unit,
                    icon: Icons.thermostat,
                    color: AppColors.chartTemp,
                    warning:
                        simService.currentTemperature.readingValue >
                        simService.maxTemperature,
                    subtitle: 'Threshold: ${simService.maxTemperature}°C',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MetricCard(
                    title: 'Gas Detector',
                    value: simService.currentGas.readingValue
                        .toInt()
                        .toString(),
                    unit: simService.currentGas.unit,
                    icon: Icons.air,
                    color: AppColors.chartGas,
                    warning:
                        simService.currentGas.readingValue >
                        simService.maxGasPpm,
                    subtitle: 'Threshold: ${simService.maxGasPpm} ppm',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: MetricCard(
                    title: 'Humidity Level',
                    value: simService.currentHumidity.readingValue
                        .toStringAsFixed(1),
                    unit: simService.currentHumidity.unit,
                    icon: Icons.water_drop,
                    color: AppColors.chartHumidity,
                    subtitle: 'Range: 30-80%',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MetricCard(
                    title: 'Vibration Sensor',
                    value: simService.currentVibration.readingValue
                        .toStringAsFixed(2),
                    unit: simService.currentVibration.unit,
                    icon: Icons.vibration,
                    color: AppColors.chartVibration,
                    warning:
                        simService.currentVibration.readingValue >
                        simService.maxVibration,
                    subtitle: 'Threshold: ${simService.maxVibration}g',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: MetricCard(
                    title: 'Heart Rate Sensor',
                    value: simService.currentHeartRate.readingValue
                        .toInt()
                        .toString(),
                    unit: simService.currentHeartRate.unit,
                    icon: Icons.favorite,
                    color: AppColors.chartHeartRate,
                    warning:
                        simService.currentHeartRate.readingValue >
                        simService.maxHeartRate,
                    subtitle: 'Threshold: ${simService.maxHeartRate} BPM',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Temperature Trend Chart
            const Text(
              'Temperature History (Last 25 Ticks)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Container(
              height: 180,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
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
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: simService.temperatureHistory.asMap().entries.map((
                        entry,
                      ) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value.readingValue,
                        );
                      }).toList(),
                      isCurved: true,
                      color: AppColors.chartTemp,
                      barWidth: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Gas Concentration Chart
            const Text(
              'Gas Concentration History (PPM)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Container(
              height: 180,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
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
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: simService.gasHistory.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value.readingValue,
                        );
                      }).toList(),
                      isCurved: true,
                      color: AppColors.chartGas,
                      barWidth: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Heart Rate Trend Chart
            const Text(
              'Worker Heart Rate History (BPM)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Container(
              height: 180,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
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
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: simService.heartRateHistory
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
                      color: AppColors.chartHeartRate,
                      barWidth: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sensor Metadata Specification Box
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Extensible Sensor Model Metadata',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Divider(),
                    _buildMetaRow(
                      'Primary Device ID',
                      simService.currentTemperature.deviceId,
                    ),
                    _buildMetaRow(
                      'Temp Sensor Hardware',
                      simService.currentTemperature.sensorId,
                    ),
                    _buildMetaRow(
                      'Gas Sensor Hardware',
                      simService.currentGas.sensorId,
                    ),
                    _buildMetaRow(
                      'Heart Rate Sensor',
                      simService.currentHeartRate.sensorId,
                    ),
                    _buildMetaRow(
                      'Data Source',
                      simService.currentTemperature.dataSource,
                    ),
                    _buildMetaRow(
                      'Connection Mode',
                      simService.currentTemperature.connectionStatus,
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

  Widget _buildMetaRow(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            k,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            v,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
