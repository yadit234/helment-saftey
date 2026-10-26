import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/worker_provider.dart';
import '../../providers/worksite_provider.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/empty_state.dart';
import '../../core/constants/app_colors.dart';
import 'worker_detail_screen.dart';
import 'add_edit_worker_screen.dart';

class WorkerListScreen extends StatelessWidget {
  const WorkerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workerProvider = Provider.of<WorkerProvider>(context);
    final worksiteProvider = Provider.of<WorksiteProvider>(context);
    final workers = workerProvider.filteredWorkers;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header & Search
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Worker Management',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${workers.length} Workers',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDarkGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by name, ID, or department...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: workerProvider.searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () =>
                                  workerProvider.setSearchQuery(''),
                            )
                          : null,
                    ),
                    onChanged: (val) => workerProvider.setSearchQuery(val),
                  ),
                  const SizedBox(height: 10),

                  // Filters Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChipDropdown<String>(
                          label: 'Site',
                          value: workerProvider.filterSiteId,
                          items: [
                            const DropdownMenuItem(
                              value: 'All',
                              child: Text('All Sites'),
                            ),
                            ...worksiteProvider.worksites.map(
                              (ws) => DropdownMenuItem(
                                value: ws.id,
                                child: Text(ws.name),
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) workerProvider.setFilterSite(val);
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterChipDropdown<String>(
                          label: 'Role',
                          value: workerProvider.filterRole,
                          items: const [
                            DropdownMenuItem(
                              value: 'All',
                              child: Text('All Roles'),
                            ),
                            DropdownMenuItem(
                              value: 'Mining Engineer',
                              child: Text('Engineer'),
                            ),
                            DropdownMenuItem(
                              value: 'Safety Technician',
                              child: Text('Safety Tech'),
                            ),
                            DropdownMenuItem(
                              value: 'Heavy Equipment Operator',
                              child: Text('Operator'),
                            ),
                            DropdownMenuItem(
                              value: 'Geologist',
                              child: Text('Geologist'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) workerProvider.setFilterRole(val);
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterChipDropdown<String>(
                          label: 'Status',
                          value: workerProvider.filterStatus,
                          items: const [
                            DropdownMenuItem(
                              value: 'All',
                              child: Text('All Statuses'),
                            ),
                            DropdownMenuItem(
                              value: 'On Duty',
                              child: Text('On Duty'),
                            ),
                            DropdownMenuItem(
                              value: 'Off Duty',
                              child: Text('Off Duty'),
                            ),
                            DropdownMenuItem(
                              value: 'Alert',
                              child: Text('Safety Alert'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              workerProvider.setFilterStatus(val);
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

            // Worker List
            Expanded(
              child: workers.isEmpty
                  ? EmptyState(
                      title: 'No Workers Found',
                      message: 'Try adjusting search or filter parameters.',
                      icon: Icons.people_outline,
                      actionLabel: 'Register New Worker',
                      onAction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddEditWorkerScreen(),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: workers.length,
                      itemBuilder: (context, index) {
                        final worker = workers[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      WorkerDetailScreen(workerId: worker.id),
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              backgroundColor: AppColors.accentMint,
                              child: Text(
                                worker.fullName.isNotEmpty
                                    ? worker.fullName[0]
                                    : 'W',
                                style: const TextStyle(
                                  color: AppColors.primaryDarkGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    worker.fullName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                StatusBadge(status: worker.safetyStatus),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  '${worker.workerCode} • ${worker.role}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  '${worker.worksiteName} • ${worker.shift}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Switch(
                              value: worker.isCheckedIn,
                              activeThumbColor: AppColors.primaryDarkGreen,
                              onChanged: (_) {
                                workerProvider.toggleCheckIn(worker.id);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryDarkGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditWorkerScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Worker'),
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
