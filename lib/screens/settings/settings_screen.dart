import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/simulation_service.dart';
import '../../services/supabase_service.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../authentication/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _supabaseUrlController;
  late TextEditingController _supabaseKeyController;

  @override
  void initState() {
    super.initState();
    _supabaseUrlController = TextEditingController(
      text: AppConstants.supabaseUrl,
    );
    _supabaseKeyController = TextEditingController(
      text: AppConstants.supabaseAnonKey,
    );
  }

  @override
  void dispose() {
    _supabaseUrlController.dispose();
    _supabaseKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final simService = Provider.of<SimulationService>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Configuration')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // User Role Profile Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User Profile & Operating Role',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.accentMint,
                        child: Icon(
                          Icons.person,
                          color: AppColors.primaryDarkGreen,
                        ),
                      ),
                      title: Text(
                        authProvider.currentUser.fullName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Role: ${authProvider.currentUser.role} • ${authProvider.currentUser.email}',
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text('Switch Account'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Simulation Thresholds Configuration
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Simulation Warning Thresholds',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Adjust limits that trigger safety alerts during simulation mode.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Divider(),

                    // Max Temperature Slider
                    Text(
                      'Max Temperature Alert Limit: ${simService.maxTemperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      value: simService.maxTemperature,
                      min: 30.0,
                      max: 50.0,
                      divisions: 20,
                      activeColor: AppColors.primaryDarkGreen,
                      label:
                          '${simService.maxTemperature.toStringAsFixed(1)}°C',
                      onChanged: (val) {
                        simService.updateThresholds(maxTemp: val);
                      },
                    ),

                    // Max Gas Slider
                    Text(
                      'Max Gas Concentration Limit: ${simService.maxGasPpm} ppm',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      value: simService.maxGasPpm.toDouble(),
                      min: 300,
                      max: 900,
                      divisions: 12,
                      activeColor: AppColors.primaryDarkGreen,
                      label: '${simService.maxGasPpm} ppm',
                      onChanged: (val) {
                        simService.updateThresholds(maxGas: val.toInt());
                      },
                    ),

                    // Max Heart Rate Slider
                    Text(
                      'Max Heart Rate Alert Limit: ${simService.maxHeartRate} BPM',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      value: simService.maxHeartRate.toDouble(),
                      min: 90,
                      max: 160,
                      divisions: 14,
                      activeColor: AppColors.primaryDarkGreen,
                      label: '${simService.maxHeartRate} BPM',
                      onChanged: (val) {
                        simService.updateThresholds(maxHeart: val.toInt());
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Optional Supabase Integration Settings
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
                          'Supabase Backend Integration',
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
                            color: SupabaseService.isConfigured
                                ? AppColors.successBackground
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            SupabaseService.isConfigured
                                ? 'CONNECTED'
                                : 'LOCAL DEMO',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: SupabaseService.isConfigured
                                  ? AppColors.successGreen
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Optional: Enter Supabase project URL and Anon key to sync database in cloud mode.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _supabaseUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Supabase URL',
                        hintText: 'https://xyz.supabase.co',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _supabaseKeyController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Anon Key'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDarkGreen,
                      ),
                      onPressed: () async {
                        final url = _supabaseUrlController.text.trim();
                        final key = _supabaseKeyController.text.trim();
                        if (url.isNotEmpty && key.isNotEmpty) {
                          await SupabaseService.initialize(
                            url: url,
                            anonKey: key,
                          );
                          setState(() {});
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  SupabaseService.isConfigured
                                      ? 'Supabase backend initialized successfully.'
                                      : 'Failed to initialize Supabase.',
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Save Supabase Credentials'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Supabase Cloud Storage Card
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
                          'Supabase Cloud Storage',
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
                            color: SupabaseService.isStorageAvailable
                                ? AppColors.successBackground
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            SupabaseService.isStorageAvailable
                                ? 'STORAGE READY'
                                : 'NOT READY',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: SupabaseService.isStorageAvailable
                                  ? AppColors.successGreen
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Supported Buckets: avatars, assets, documents, safety-files',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Divider(),
                    const Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        Chip(
                          avatar: Icon(Icons.folder, size: 16),
                          label: Text('avatars', style: TextStyle(fontSize: 11)),
                        ),
                        Chip(
                          avatar: Icon(Icons.folder, size: 16),
                          label: Text('assets', style: TextStyle(fontSize: 11)),
                        ),
                        Chip(
                          avatar: Icon(Icons.folder, size: 16),
                          label: Text('documents', style: TextStyle(fontSize: 11)),
                        ),
                        Chip(
                          avatar: Icon(Icons.folder, size: 16),
                          label: Text('safety-files', style: TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.cloud_upload),
                      label: const Text('TEST STORAGE UPLOAD'),
                      onPressed: () async {
                        if (!SupabaseService.isStorageAvailable) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Supabase is not configured or connected.',
                              ),
                            ),
                          );
                          return;
                        }

                        final testPath =
                            'test_log_${DateTime.now().millisecondsSinceEpoch}.txt';
                        final url = await SupabaseService.uploadString(
                          bucket: SupabaseService.bucketSafetyFiles,
                          path: testPath,
                          data:
                              'MineGuard Safety Log generated at ${DateTime.now()}',
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                url != null
                                    ? 'Uploaded test log to Supabase Storage!'
                                    : 'Upload failed. Verify bucket "${SupabaseService.bucketSafetyFiles}" exists on Supabase.',
                              ),
                            ),
                          );
                        }
                      },
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
