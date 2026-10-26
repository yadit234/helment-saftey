import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'services/storage_service.dart';
import 'services/simulation_service.dart';

import 'repositories/worker_repository.dart';
import 'repositories/asset_repository.dart';
import 'repositories/alert_repository.dart';
import 'repositories/monitoring_repository.dart';
import 'repositories/worksite_repository.dart';

import 'providers/auth_provider.dart';
import 'providers/worksite_provider.dart';
import 'providers/worker_provider.dart';
import 'providers/asset_provider.dart';
import 'providers/monitoring_provider.dart';
import 'providers/alert_provider.dart';
import 'providers/dashboard_provider.dart';

import 'screens/main_navigation_screen.dart';

class MineGuardApp extends StatelessWidget {
  final StorageService storageService;

  const MineGuardApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    // Instantiate Repositories
    final worksiteRepo = WorksiteRepository(storageService);
    final workerRepo = WorkerRepository(storageService);
    final assetRepo = AssetRepository(storageService);
    final alertRepo = AlertRepository(storageService);
    final monitoringRepo = MonitoringRepository(storageService);

    // Instantiate Central Simulation Service
    final simulationService = SimulationService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => simulationService),
        ChangeNotifierProvider(create: (_) => WorksiteProvider(worksiteRepo)),
        ChangeNotifierProvider(create: (_) => WorkerProvider(workerRepo)),
        ChangeNotifierProvider(create: (_) => AssetProvider(assetRepo)),
        ChangeNotifierProvider(
          create: (_) => MonitoringProvider(monitoringRepo, simulationService),
        ),
        ChangeNotifierProvider(
          create: (_) => AlertProvider(alertRepo, simulationService),
        ),
        ChangeNotifierProxyProvider4<
          WorkerProvider,
          AssetProvider,
          AlertProvider,
          SimulationService,
          DashboardProvider
        >(
          create: (ctx) => DashboardProvider(
            workerProvider: Provider.of<WorkerProvider>(ctx, listen: false),
            assetProvider: Provider.of<AssetProvider>(ctx, listen: false),
            alertProvider: Provider.of<AlertProvider>(ctx, listen: false),
            simulationService: simulationService,
          ),
          update: (ctx, workerP, assetP, alertP, simS, previous) {
            return DashboardProvider(
              workerProvider: workerP,
              assetProvider: assetP,
              alertProvider: alertP,
              simulationService: simS,
            );
          },
        ),
      ],
      child: MaterialApp(
        title: 'MineGuard',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}
