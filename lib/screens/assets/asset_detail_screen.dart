import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/asset_provider.dart';
import '../../widgets/status_badge.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import 'add_edit_asset_screen.dart';

class AssetDetailScreen extends StatelessWidget {
  final String assetId;

  const AssetDetailScreen({super.key, required this.assetId});

  @override
  Widget build(BuildContext context) {
    final assetProvider = Provider.of<AssetProvider>(context);

    final assetList = assetProvider.assets
        .where((a) => a.id == assetId)
        .toList();
    if (assetList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Asset Detail')),
        body: const Center(child: Text('Asset record not found.')),
      );
    }

    final asset = assetList.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(asset.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditAssetScreen(asset: asset),
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
                  title: const Text('Delete Asset'),
                  content: Text(
                    'Are you sure you want to delete ${asset.name}?',
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
                await assetProvider.deleteAsset(asset.id);
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
            // Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.accentMint,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.precision_manufacturing,
                        size: 40,
                        color: AppColors.primaryDarkGreen,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      asset.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${asset.assetCode} • ${asset.manufacturer} ${asset.model}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StatusBadge(status: asset.operationalStatus),
                        const SizedBox(width: 10),
                        StatusBadge(
                          status: 'Maint: ${asset.maintenanceStatus}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Specifications & Location
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Asset Specifications',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _buildRow('Category', asset.category),
                    _buildRow('Manufacturer', asset.manufacturer),
                    _buildRow('Model Number', asset.model),
                    _buildRow('Assigned Worksite', asset.worksiteName),
                    _buildRow(
                      'Assigned Operator',
                      asset.assignedOperator ?? 'Unassigned',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Maintenance Schedule
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Inspection & Maintenance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _buildRow(
                      'Last Inspection',
                      DateFormatter.formatShortDate(asset.lastInspectionDate),
                    ),
                    _buildRow(
                      'Next Maintenance',
                      DateFormatter.formatShortDate(asset.nextMaintenanceDate),
                    ),
                    _buildRow('Maintenance Status', asset.maintenanceStatus),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Operational Status Controls
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Update Operational Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  asset.operationalStatus == 'Operational'
                                  ? AppColors.primaryDarkGreen
                                  : Colors.grey.shade300,
                              foregroundColor:
                                  asset.operationalStatus == 'Operational'
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onPressed: () {
                              assetProvider.toggleOperationalStatus(
                                asset.id,
                                'Operational',
                              );
                            },
                            child: const Text('Operational'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  asset.operationalStatus ==
                                      'Maintenance Required'
                                  ? AppColors.warningAmber
                                  : Colors.grey.shade300,
                              foregroundColor:
                                  asset.operationalStatus ==
                                      'Maintenance Required'
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onPressed: () {
                              assetProvider.toggleOperationalStatus(
                                asset.id,
                                'Maintenance Required',
                              );
                            },
                            child: const Text('Maintenance'),
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

  Widget _buildRow(String label, String value) {
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
