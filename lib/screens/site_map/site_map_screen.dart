import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../providers/worksite_provider.dart';
import '../../providers/worker_provider.dart';
import '../../providers/asset_provider.dart';
import '../../widgets/status_badge.dart';
import '../../core/constants/app_colors.dart';

class SiteMapScreen extends StatefulWidget {
  const SiteMapScreen({super.key});

  @override
  State<SiteMapScreen> createState() => _SiteMapScreenState();
}

class _SiteMapScreenState extends State<SiteMapScreen> {
  String? _selectedMarkerTitle;
  String? _selectedMarkerSubtitle;
  String? _selectedMarkerType;

  @override
  Widget build(BuildContext context) {
    final worksiteProvider = Provider.of<WorksiteProvider>(context);
    final workerProvider = Provider.of<WorkerProvider>(context);
    final assetProvider = Provider.of<AssetProvider>(context);

    final activeWorksite = worksiteProvider.selectedWorksite;
    final centerLatLng = LatLng(
      activeWorksite.latitude,
      activeWorksite.longitude,
    );

    final markers = <Marker>[];

    // 1. Worksite Marker
    markers.add(
      Marker(
        point: centerLatLng,
        width: 44,
        height: 44,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedMarkerTitle = activeWorksite.name;
              _selectedMarkerSubtitle =
                  'Primary Worksite HQ • ${activeWorksite.location}';
              _selectedMarkerType = 'Worksite';
            });
          },
          child: const Icon(
            Icons.location_on,
            color: AppColors.primaryDarkGreen,
            size: 44,
          ),
        ),
      ),
    );

    // 2. Worker Markers
    for (var w in workerProvider.workers) {
      if (w.latitude != null && w.longitude != null) {
        markers.add(
          Marker(
            point: LatLng(w.latitude!, w.longitude!),
            width: 36,
            height: 36,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMarkerTitle = w.fullName;
                  _selectedMarkerSubtitle =
                      '${w.role} • ${w.safetyStatus} • Shift: ${w.shift}';
                  _selectedMarkerType = 'Worker';
                });
              },
              child: CircleAvatar(
                backgroundColor: w.safetyStatus != 'Normal'
                    ? AppColors.criticalRed
                    : AppColors.primaryTeal,
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ),
        );
      }
    }

    // 3. Asset Markers
    for (var a in assetProvider.assets) {
      markers.add(
        Marker(
          point: LatLng(a.latitude, a.longitude),
          width: 36,
          height: 36,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedMarkerTitle = a.name;
                _selectedMarkerSubtitle =
                    '${a.category} • ${a.operationalStatus}';
                _selectedMarkerType = 'Asset';
              });
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.precision_manufacturing,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Interactive Site Map')),
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: centerLatLng,
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.mineguard.app',
                  errorTileCallback: (tile, error, stackTrace) {
                    // Graceful offline fallback
                  },
                ),
                MarkerLayer(markers: markers),
              ],
            ),

            // Top Notice
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.map,
                      size: 18,
                      color: AppColors.primaryDarkGreen,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Simulated GPS Positions • Tap markers to view details',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Selected Marker Callout Bottom Card
            if (_selectedMarkerTitle != null)
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: Card(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.accentMint,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _selectedMarkerType == 'Worker'
                                ? Icons.person
                                : _selectedMarkerType == 'Asset'
                                ? Icons.precision_manufacturing
                                : Icons.location_on,
                            color: AppColors.primaryDarkGreen,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _selectedMarkerTitle!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  if (_selectedMarkerType != null)
                                    StatusBadge(status: _selectedMarkerType!),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _selectedMarkerSubtitle ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _selectedMarkerTitle = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
