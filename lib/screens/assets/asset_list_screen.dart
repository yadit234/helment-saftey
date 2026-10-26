import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/asset_provider.dart';
import '../../providers/worksite_provider.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/empty_state.dart';
import '../../core/constants/app_colors.dart';
import 'asset_detail_screen.dart';
import 'add_edit_asset_screen.dart';

class AssetListScreen extends StatelessWidget {
  const AssetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final assetProvider = Provider.of<AssetProvider>(context);
    final worksiteProvider = Provider.of<WorksiteProvider>(context);
    final assets = assetProvider.filteredAssets;

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
                        'Asset & Equipment',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${assets.length} Assets',
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
                      hintText:
                          'Search asset name, ID, model, or manufacturer...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: assetProvider.searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => assetProvider.setSearchQuery(''),
                            )
                          : null,
                    ),
                    onChanged: (val) => assetProvider.setSearchQuery(val),
                  ),
                  const SizedBox(height: 10),

                  // Filter dropdowns
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChipDropdown<String>(
                          label: 'Site',
                          value: assetProvider.filterSiteId,
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
                            if (val != null) assetProvider.setFilterSite(val);
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterChipDropdown<String>(
                          label: 'Category',
                          value: assetProvider.filterCategory,
                          items: const [
                            DropdownMenuItem(
                              value: 'All',
                              child: Text('All Categories'),
                            ),
                            DropdownMenuItem(
                              value: 'Excavators',
                              child: Text('Excavators'),
                            ),
                            DropdownMenuItem(
                              value: 'Cranes',
                              child: Text('Cranes'),
                            ),
                            DropdownMenuItem(
                              value: 'Haul Trucks',
                              child: Text('Haul Trucks'),
                            ),
                            DropdownMenuItem(
                              value: 'Drilling Rigs',
                              child: Text('Drilling Rigs'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              assetProvider.setFilterCategory(val);
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterChipDropdown<String>(
                          label: 'Status',
                          value: assetProvider.filterStatus,
                          items: const [
                            DropdownMenuItem(
                              value: 'All',
                              child: Text('All Statuses'),
                            ),
                            DropdownMenuItem(
                              value: 'Operational',
                              child: Text('Operational'),
                            ),
                            DropdownMenuItem(
                              value: 'Maintenance Required',
                              child: Text('Maintenance Req'),
                            ),
                            DropdownMenuItem(
                              value: 'Out of Service',
                              child: Text('Out of Service'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) assetProvider.setFilterStatus(val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Assets List
            Expanded(
              child: assets.isEmpty
                  ? EmptyState(
                      title: 'No Assets Registered',
                      message: 'Try adjusting search or filter parameters.',
                      icon: Icons.precision_manufacturing_outlined,
                      actionLabel: 'Register New Asset',
                      onAction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddEditAssetScreen(),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: assets.length,
                      itemBuilder: (context, index) {
                        final asset = assets[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AssetDetailScreen(assetId: asset.id),
                                ),
                              );
                            },
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.accentMint,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.precision_manufacturing,
                                color: AppColors.primaryDarkGreen,
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    asset.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                StatusBadge(status: asset.operationalStatus),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  '${asset.assetCode} • ${asset.manufacturer} ${asset.model}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  'Site: ${asset.worksiteName} • Maint: ${asset.maintenanceStatus}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
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
            MaterialPageRoute(builder: (_) => const AddEditAssetScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Register Asset'),
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
