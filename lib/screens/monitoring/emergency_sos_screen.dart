import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/monitoring_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';

class EmergencySosScreen extends StatelessWidget {
  const EmergencySosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final monitoringProvider = Provider.of<MonitoringProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isSosActive = monitoringProvider.sosActive;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency SOS Interface'),
        backgroundColor: AppColors.criticalRed,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Warning Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warningAmber),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.warningAmber,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'TEST / DEMO MODE ONLY: Activating SOS creates a local test event. No external emergency services or supervisors will be contacted.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // SOS Active Indicator Banner
            if (isSosActive) ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.criticalBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.criticalRed, width: 2),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.warning,
                      color: AppColors.criticalRed,
                      size: 48,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'TEST SOS ACTIVATED',
                      style: TextStyle(
                        color: AppColors.criticalRed,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Activated by ${authProvider.currentUser.fullName}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDarkGreen,
                      ),
                      onPressed: () {
                        monitoringProvider.resetTestSOS();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Test SOS Signal Reset.'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('RESET / CANCEL TEST SOS'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],

            // Prominent SOS Button
            Center(
              child: GestureDetector(
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Activate Test SOS Signal?'),
                      content: const Text(
                        'This will simulate an emergency broadcast for your current worksite. No external emergency services will be contacted.',
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
                          child: const Text('ACTIVATE TEST SOS'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    monitoringProvider.activateTestSOS(
                      authProvider.currentUser.id,
                      authProvider.currentUser.fullName,
                    );
                  }
                },
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.criticalRed,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.criticalRed.withOpacity(0.4),
                        blurRadius: 24,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.emergency, color: Colors.white, size: 50),
                        SizedBox(height: 6),
                        Text(
                          'TEST SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            const Center(
              child: Text(
                'Tap to trigger simulated emergency SOS broadcast',
                style: TextStyle(fontSize: 12, color: AppColors.textLight),
              ),
            ),
            const SizedBox(height: 30),

            // Configured Emergency Contacts List
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Emergency Contact Dispatch List',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Configured emergency response personnel for current site',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(
                        Icons.local_hospital,
                        color: AppColors.criticalRed,
                      ),
                      title: Text('Site First Aid Station'),
                      subtitle: Text('Ext: 9110 • Sector 4 Dispatch'),
                    ),
                    const ListTile(
                      leading: Icon(
                        Icons.security,
                        color: AppColors.primaryDarkGreen,
                      ),
                      title: Text('Chief Safety Officer'),
                      subtitle: Text('+1 555-0199 • On Duty'),
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
}
