import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/alert_provider.dart';
import '../../widgets/alert_card.dart';
import '../../widgets/empty_state.dart';
import '../../core/constants/app_colors.dart';

class AlertListScreen extends StatelessWidget {
  const AlertListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context);
    final alerts = alertProvider.filteredAlerts;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search & Filter Header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Alert Management',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${alertProvider.activeAlertsCount} Active',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.criticalRed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search alert messages or titles...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: alertProvider.searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => alertProvider.setSearchQuery(''),
                            )
                          : null,
                    ),
                    onChanged: (val) => alertProvider.setSearchQuery(val),
                  ),
                  const SizedBox(height: 10),

                  // Filter Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChipDropdown<String>(
                          label: 'Status',
                          value: alertProvider.filterStatus,
                          items: const [
                            DropdownMenuItem(
                              value: 'All',
                              child: Text('All Statuses'),
                            ),
                            DropdownMenuItem(
                              value: 'Active',
                              child: Text('Active Only'),
                            ),
                            DropdownMenuItem(
                              value: 'Acknowledged',
                              child: Text('Acknowledged'),
                            ),
                            DropdownMenuItem(
                              value: 'Resolved',
                              child: Text('Resolved'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) alertProvider.setFilterStatus(val);
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterChipDropdown<String>(
                          label: 'Severity',
                          value: alertProvider.filterSeverity,
                          items: const [
                            DropdownMenuItem(
                              value: 'All',
                              child: Text('All Severities'),
                            ),
                            DropdownMenuItem(
                              value: 'Critical',
                              child: Text('Critical'),
                            ),
                            DropdownMenuItem(
                              value: 'High',
                              child: Text('High'),
                            ),
                            DropdownMenuItem(
                              value: 'Warning',
                              child: Text('Warning'),
                            ),
                            DropdownMenuItem(
                              value: 'Info',
                              child: Text('Info'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              alertProvider.setFilterSeverity(val);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Alert List
            Expanded(
              child: alerts.isEmpty
                  ? EmptyState(
                      title: 'No Alerts Found',
                      message: 'No safety alerts match the active filters.',
                      icon: Icons.notifications_none,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: alerts.length,
                      itemBuilder: (context, index) {
                        final alert = alerts[index];
                        return AlertCard(
                          alert: alert,
                          onAcknowledge: () {
                            alertProvider.acknowledgeAlert(alert.id);
                          },
                          onResolve: () async {
                            final notesController = TextEditingController();
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Resolve Safety Alert'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Resolving alert: ${alert.title}'),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: notesController,
                                      decoration: const InputDecoration(
                                        labelText:
                                            'Investigation / Action Notes',
                                        hintText: 'Enter resolution details...',
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Resolve'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await alertProvider.resolveAlert(
                                alert.id,
                                notesController.text.trim().isEmpty
                                    ? 'Resolved by inspector.'
                                    : notesController.text.trim(),
                              );
                            }
                          },
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

class _FilterChipDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _FilterChipDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasMatch = items.any((item) => item.value == value);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: hasMatch ? value : (items.isNotEmpty ? items.first.value : null),
          icon: const Icon(Icons.arrow_drop_down, size: 18),
          style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
          onChanged: onChanged,
          items: items,
        ),
      ),
    );
  }
}
