import 'package:flutter/foundation.dart';

import 'worker_provider.dart';
import 'asset_provider.dart';
import 'alert_provider.dart';
import '../services/simulation_service.dart';

class DashboardProvider extends ChangeNotifier {
  final WorkerProvider workerProvider;
  final AssetProvider assetProvider;
  final AlertProvider alertProvider;
  final SimulationService simulationService;

  DashboardProvider({
    required this.workerProvider,
    required this.assetProvider,
    required this.alertProvider,
    required this.simulationService,
  });

  // Dynamic values derived directly from state repositories
  int get totalWorkers => workerProvider.totalWorkersCount;
  int get workersOnDuty => workerProvider.onDutyWorkersCount;
  int get workersWithAlerts => workerProvider.alertWorkersCount;

  int get totalAssets => assetProvider.totalAssetsCount;
  int get operationalAssets => assetProvider.operationalAssetsCount;
  int get maintenanceAlertAssets => assetProvider.maintenanceAlertsCount;

  int get activeAlerts => alertProvider.activeAlertsCount;
  int get criticalAlerts => alertProvider.criticalAlertsCount;

  double get currentTemperature =>
      simulationService.currentTemperature.readingValue;
  int get currentGasLevel => simulationService.currentGas.readingValue.toInt();
  double get currentHumidity => simulationService.currentHumidity.readingValue;
  double get currentVibration =>
      simulationService.currentVibration.readingValue;
  int get currentHeartRate =>
      simulationService.currentHeartRate.readingValue.toInt();

  bool get isHighTemp => currentTemperature > simulationService.maxTemperature;
  bool get isHighGas => currentGasLevel > simulationService.maxGasPpm;
  bool get isHighVib => currentVibration > simulationService.maxVibration;
  bool get isHighHeartRate =>
      currentHeartRate > simulationService.maxHeartRate;

  bool get overallWarning =>
      isHighTemp ||
      isHighGas ||
      isHighVib ||
      isHighHeartRate ||
      workersWithAlerts > 0 ||
      criticalAlerts > 0;

  String get overallStatusText =>
      overallWarning ? 'WARNING DETECTED' : 'SYSTEM NORMAL';


}
