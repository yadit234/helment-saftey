import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/sensor_reading.dart';
import '../models/safety_event.dart';
import '../models/alert.dart';
import '../core/constants/app_constants.dart';

class SimulationService extends ChangeNotifier {
  final Random _random = Random();
  Timer? _timer;

  bool _isSimulating = true;
  int _updateIntervalSeconds = 2;

  String _currentWorksiteId = 'site_alpha';

  // Configurable thresholds
  double maxTemperature = AppConstants.defaultMaxTemperature;
  int maxGasPpm = AppConstants.defaultMaxGasPpm;
  double maxVibration = AppConstants.defaultMaxVibration;
  double minHumidity = AppConstants.defaultMinHumidity;
  double maxHumidity = AppConstants.defaultMaxHumidity;
  int maxHeartRate = AppConstants.defaultMaxHeartRate;

  // Latest readings
  late SensorReading currentTemperature;
  late SensorReading currentGas;
  late SensorReading currentHumidity;
  late SensorReading currentVibration;
  late SensorReading currentHeartRate;

  // History buffer for charts (last 25 readings)
  final List<SensorReading> temperatureHistory = [];
  final List<SensorReading> gasHistory = [];
  final List<SensorReading> humidityHistory = [];
  final List<SensorReading> vibrationHistory = [];
  final List<SensorReading> heartRateHistory = [];

  // Stream controllers for external listeners
  final StreamController<SafetyEvent> _eventStreamController =
      StreamController<SafetyEvent>.broadcast();
  final StreamController<Alert> _alertStreamController =
      StreamController<Alert>.broadcast();

  Stream<SafetyEvent> get onSafetyEvent => _eventStreamController.stream;
  Stream<Alert> get onAlert => _alertStreamController.stream;

  bool get isSimulating => _isSimulating;
  int get updateIntervalSeconds => _updateIntervalSeconds;
  String get currentWorksiteId => _currentWorksiteId;

  // Track recent alert timestamps for duplicate suppression
  DateTime? _lastTempAlertTime;
  DateTime? _lastGasAlertTime;
  DateTime? _lastFallAlertTime;
  DateTime? _lastHeartAlertTime;

  SimulationService() {
    _initDefaultReadings();
    startSimulation();
  }

  void _initDefaultReadings() {
    final now = DateTime.now();
    currentTemperature = SensorReading(
      id: 'sr_temp_init',
      deviceId: 'ESP32_SIM_01',
      sensorId: 'DHT22_TEMP',
      sensorType: 'Temperature',
      readingValue: 31.5,
      unit: '°C',
      timestamp: now,
      worksiteId: _currentWorksiteId,
      dataSource: AppConstants.dataSourceSimulated,
    );

    currentGas = SensorReading(
      id: 'sr_gas_init',
      deviceId: 'ESP32_SIM_01',
      sensorId: 'MQ135_GAS',
      sensorType: 'Gas',
      readingValue: 320,
      unit: 'ppm (simulated)',
      timestamp: now,
      worksiteId: _currentWorksiteId,
      dataSource: AppConstants.dataSourceSimulated,
    );

    currentHumidity = SensorReading(
      id: 'sr_hum_init',
      deviceId: 'ESP32_SIM_01',
      sensorId: 'DHT22_HUM',
      sensorType: 'Humidity',
      readingValue: 55.0,
      unit: '%',
      timestamp: now,
      worksiteId: _currentWorksiteId,
      dataSource: AppConstants.dataSourceSimulated,
    );

    currentVibration = SensorReading(
      id: 'sr_vib_init',
      deviceId: 'ESP32_SIM_01',
      sensorId: 'MPU6050_VIB',
      sensorType: 'Vibration',
      readingValue: 0.8,
      unit: 'g',
      timestamp: now,
      worksiteId: _currentWorksiteId,
      dataSource: AppConstants.dataSourceSimulated,
    );

    currentHeartRate = SensorReading(
      id: 'sr_hr_init',
      deviceId: 'ESP32_SIM_01',
      sensorId: 'MAX30102_PULSE',
      sensorType: 'Heart Rate',
      readingValue: 75.0,
      unit: 'BPM',
      timestamp: now,
      worksiteId: _currentWorksiteId,
      dataSource: AppConstants.dataSourceSimulated,
    );

    _pushToHistory(
      currentTemperature,
      currentGas,
      currentHumidity,
      currentVibration,
      currentHeartRate,
    );
  }

  void setWorksite(String worksiteId) {
    _currentWorksiteId = worksiteId;
    generateNextReading();
  }

  void updateInterval(int seconds) {
    _updateIntervalSeconds = seconds;
    if (_isSimulating) {
      startSimulation();
    }
  }

  void updateThresholds({
    double? maxTemp,
    int? maxGas,
    double? maxVib,
    int? maxHeart,
  }) {
    if (maxTemp != null) maxTemperature = maxTemp;
    if (maxGas != null) maxGasPpm = maxGas;
    if (maxVib != null) maxVibration = maxVib;
    if (maxHeart != null) maxHeartRate = maxHeart;
    notifyListeners();
  }

  void startSimulation() {
    _timer?.cancel();
    _isSimulating = true;
    _timer = Timer.periodic(
      Duration(seconds: _updateIntervalSeconds),
      (_) => generateNextReading(),
    );
    notifyListeners();
  }

  void pauseSimulation() {
    _timer?.cancel();
    _isSimulating = false;
    notifyListeners();
  }

  void toggleSimulation() {
    if (_isSimulating) {
      pauseSimulation();
    } else {
      startSimulation();
    }
  }

  void generateNextReading() {
    final now = DateTime.now();

    // 1. Temperature random walk around 28 - 44
    double nextTemp =
        currentTemperature.readingValue + (_random.nextDouble() * 2.4 - 1.2);
    if (nextTemp < 20.0) nextTemp = 20.0;
    if (nextTemp > 48.0) nextTemp = 48.0;

    // 2. Gas random walk around 150 - 850
    int nextGas = (currentGas.readingValue + (_random.nextInt(61) - 30))
        .toInt();
    if (nextGas < 100) nextGas = 100;
    if (nextGas > 950) nextGas = 950;

    // 3. Humidity random walk around 35 - 85
    double nextHum =
        currentHumidity.readingValue + (_random.nextDouble() * 2.0 - 1.0);
    if (nextHum < 20.0) nextHum = 20.0;
    if (nextHum > 95.0) nextHum = 95.0;

    // 4. Vibration random walk
    double nextVib =
        currentVibration.readingValue + (_random.nextDouble() * 0.6 - 0.3);
    if (nextVib < 0.1) nextVib = 0.1;
    if (nextVib > 6.0) nextVib = 6.0;

    // 5. Heart rate random walk around 65 - 135 BPM
    int nextHR =
        (currentHeartRate.readingValue + (_random.nextInt(7) - 3)).toInt();
    if (nextHR < 55) nextHR = 55;
    if (nextHR > 155) nextHR = 155;

    currentTemperature = SensorReading(
      id: 'sr_temp_${now.millisecondsSinceEpoch}',
      deviceId: 'ESP32_SIM_01',
      sensorId: 'DHT22_TEMP',
      sensorType: 'Temperature',
      readingValue: double.parse(nextTemp.toStringAsFixed(1)),
      unit: '°C',
      timestamp: now,
      worksiteId: _currentWorksiteId,
      dataSource: AppConstants.dataSourceSimulated,
    );

    currentGas = SensorReading(
      id: 'sr_gas_${now.millisecondsSinceEpoch}',
      deviceId: 'ESP32_SIM_01',
      sensorId: 'MQ135_GAS',
      sensorType: 'Gas',
      readingValue: nextGas.toDouble(),
      unit: 'ppm (simulated)',
      timestamp: now,
      worksiteId: _currentWorksiteId,
      dataSource: AppConstants.dataSourceSimulated,
    );

    currentHumidity = SensorReading(
      id: 'sr_hum_${now.millisecondsSinceEpoch}',
      deviceId: 'ESP32_SIM_01',
      sensorId: 'DHT22_HUM',
      sensorType: 'Humidity',
      readingValue: double.parse(nextHum.toStringAsFixed(1)),
      unit: '%',
      timestamp: now,
      worksiteId: _currentWorksiteId,
      dataSource: AppConstants.dataSourceSimulated,
    );

    currentVibration = SensorReading(
      id: 'sr_vib_${now.millisecondsSinceEpoch}',
      deviceId: 'ESP32_SIM_01',
      sensorId: 'MPU6050_VIB',
      sensorType: 'Vibration',
      readingValue: double.parse(nextVib.toStringAsFixed(2)),
      unit: 'g',
      timestamp: now,
      worksiteId: _currentWorksiteId,
      dataSource: AppConstants.dataSourceSimulated,
    );

    currentHeartRate = SensorReading(
      id: 'sr_hr_${now.millisecondsSinceEpoch}',
      deviceId: 'ESP32_SIM_01',
      sensorId: 'MAX30102_PULSE',
      sensorType: 'Heart Rate',
      readingValue: nextHR.toDouble(),
      unit: 'BPM',
      timestamp: now,
      worksiteId: _currentWorksiteId,
      dataSource: AppConstants.dataSourceSimulated,
    );

    _pushToHistory(
      currentTemperature,
      currentGas,
      currentHumidity,
      currentVibration,
      currentHeartRate,
    );
    _evaluateThresholdsAndEvents(now);

    notifyListeners();
  }

  void _pushToHistory(
    SensorReading temp,
    SensorReading gas,
    SensorReading hum,
    SensorReading vib,
    SensorReading hr,
  ) {
    temperatureHistory.add(temp);
    if (temperatureHistory.length > 25) temperatureHistory.removeAt(0);

    gasHistory.add(gas);
    if (gasHistory.length > 25) gasHistory.removeAt(0);

    humidityHistory.add(hum);
    if (humidityHistory.length > 25) humidityHistory.removeAt(0);

    vibrationHistory.add(vib);
    if (vibrationHistory.length > 25) vibrationHistory.removeAt(0);

    heartRateHistory.add(hr);
    if (heartRateHistory.length > 25) heartRateHistory.removeAt(0);
  }

  void _evaluateThresholdsAndEvents(DateTime now) {
    // Duplicate alert suppression window: 30 seconds
    const suppressionWindow = Duration(seconds: 30);

    // 1. High Temperature Alert
    if (currentTemperature.readingValue > maxTemperature) {
      if (_lastTempAlertTime == null ||
          now.difference(_lastTempAlertTime!) > suppressionWindow) {
        _lastTempAlertTime = now;
        final event = SafetyEvent(
          id: 'evt_temp_${now.millisecondsSinceEpoch}',
          eventType: 'High Temperature',
          severity: AppConstants.severityWarning,
          timestamp: now,
          worksiteId: _currentWorksiteId,
          description:
              'Simulated temperature spike: ${currentTemperature.readingValue}°C (Threshold: $maxTemperature°C)',
          dataSource: AppConstants.dataSourceSimulated,
        );

        final alert = Alert(
          id: 'alt_temp_${now.millisecondsSinceEpoch}',
          title: 'High Temperature Spike',
          message:
              'Temperature in $_currentWorksiteId reached ${currentTemperature.readingValue}°C',
          severity: AppConstants.severityWarning,
          timestamp: now,
          worksiteId: _currentWorksiteId,
          alertType: 'Environmental',
          dataSource: AppConstants.dataSourceSimulated,
        );

        _eventStreamController.add(event);
        _alertStreamController.add(alert);
      }
    }

    // 2. High Gas Level Alert
    if (currentGas.readingValue > maxGasPpm) {
      if (_lastGasAlertTime == null ||
          now.difference(_lastGasAlertTime!) > suppressionWindow) {
        _lastGasAlertTime = now;
        final event = SafetyEvent(
          id: 'evt_gas_${now.millisecondsSinceEpoch}',
          eventType: 'Gas Spike',
          severity: AppConstants.severityHigh,
          timestamp: now,
          worksiteId: _currentWorksiteId,
          description:
              'Simulated gas reading exceeded safety threshold: ${currentGas.readingValue.toInt()} ppm (Threshold: $maxGasPpm ppm)',
          dataSource: AppConstants.dataSourceSimulated,
        );

        final alert = Alert(
          id: 'alt_gas_${now.millisecondsSinceEpoch}',
          title: 'Elevated Gas Level Detected',
          message:
              'Gas concentration in $_currentWorksiteId reached ${currentGas.readingValue.toInt()} ppm',
          severity: AppConstants.severityHigh,
          timestamp: now,
          worksiteId: _currentWorksiteId,
          alertType: 'Environmental',
          dataSource: AppConstants.dataSourceSimulated,
        );

        _eventStreamController.add(event);
        _alertStreamController.add(alert);
      }
    }

    // 3. High Heart Rate Alert (Tachycardia / Physical Distress)
    if (currentHeartRate.readingValue > maxHeartRate) {
      if (_lastHeartAlertTime == null ||
          now.difference(_lastHeartAlertTime!) > suppressionWindow) {
        _lastHeartAlertTime = now;
        final event = SafetyEvent(
          id: 'evt_hr_${now.millisecondsSinceEpoch}',
          eventType: 'Abnormal Heart Rate',
          severity: AppConstants.severityCritical,
          timestamp: now,
          worksiteId: _currentWorksiteId,
          description:
              'Simulated pulse sensor spike: ${currentHeartRate.readingValue.toInt()} BPM (Threshold: $maxHeartRate BPM). Worker physical distress.',
          dataSource: AppConstants.dataSourceSimulated,
        );

        final alert = Alert(
          id: 'alt_hr_${now.millisecondsSinceEpoch}',
          title: 'Abnormal Heart Rate Spike',
          message:
              'Worker heart rate in $_currentWorksiteId reached ${currentHeartRate.readingValue.toInt()} BPM',
          severity: AppConstants.severityCritical,
          timestamp: now,
          worksiteId: _currentWorksiteId,
          alertType: 'Worker Safety',
          dataSource: AppConstants.dataSourceSimulated,
        );

        _eventStreamController.add(event);
        _alertStreamController.add(alert);
      }
    }

    // 4. Fall Detection Simulation (Random chance 1 in 25 ticks)
    if (_random.nextInt(25) == 0) {
      if (_lastFallAlertTime == null ||
          now.difference(_lastFallAlertTime!) > suppressionWindow) {
        _lastFallAlertTime = now;
        final workerNames = [
          'David K. Lawson',
          'Marcus Vance',
          'Elena Rostova',
          'Amina Mohamed',
        ];
        final workerIds = ['w_01', 'w_03', 'w_02', 'w_04'];
        final idx = _random.nextInt(workerNames.length);

        final event = SafetyEvent(
          id: 'evt_fall_${now.millisecondsSinceEpoch}',
          workerId: workerIds[idx],
          workerName: workerNames[idx],
          eventType: 'Fall Detection',
          severity: AppConstants.severityCritical,
          timestamp: now,
          worksiteId: _currentWorksiteId,
          description:
              'Simulated accelerometer impact detected. Possible worker fall event for ${workerNames[idx]}.',
          dataSource: AppConstants.dataSourceSimulated,
        );

        final alert = Alert(
          id: 'alt_fall_${now.millisecondsSinceEpoch}',
          title: 'Worker Fall Alert',
          message:
              'Possible fall event for ${workerNames[idx]} at $_currentWorksiteId',
          severity: AppConstants.severityCritical,
          timestamp: now,
          worksiteId: _currentWorksiteId,
          alertType: 'Worker Safety',
          workerId: workerIds[idx],
          dataSource: AppConstants.dataSourceSimulated,
        );

        _eventStreamController.add(event);
        _alertStreamController.add(alert);
      }
    }
  }

  // Helper trigger methods for manual simulation actions
  void triggerHeartRateSpike(String workerId, String workerName) {
    final now = DateTime.now();
    currentHeartRate = SensorReading(
      id: 'sr_hr_${now.millisecondsSinceEpoch}',
      deviceId: 'ESP32_SIM_01',
      sensorId: 'MAX30102_PULSE',
      sensorType: 'Heart Rate',
      readingValue: 142.0,
      unit: 'BPM',
      timestamp: now,
      worksiteId: _currentWorksiteId,
      dataSource: AppConstants.dataSourceSimulated,
    );
    heartRateHistory.add(currentHeartRate);

    final event = SafetyEvent(
      id: 'evt_hr_manual_${now.millisecondsSinceEpoch}',
      workerId: workerId,
      workerName: workerName,
      eventType: 'Abnormal Heart Rate',
      severity: AppConstants.severityCritical,
      timestamp: now,
      worksiteId: _currentWorksiteId,
      description:
          'Manual simulated pulse sensor spike (142 BPM) for $workerName.',
      dataSource: AppConstants.dataSourceSimulated,
    );

    final alert = Alert(
      id: 'alt_hr_manual_${now.millisecondsSinceEpoch}',
      title: 'Tachycardia Heart Rate Triggered',
      message: 'Simulated heart rate spike (142 BPM) for $workerName',
      severity: AppConstants.severityCritical,
      timestamp: now,
      worksiteId: _currentWorksiteId,
      alertType: 'Worker Safety',
      workerId: workerId,
      dataSource: AppConstants.dataSourceSimulated,
    );

    _eventStreamController.add(event);
    _alertStreamController.add(alert);
    notifyListeners();
  }

  void triggerManualFallSimulation(String workerId, String workerName) {
    final now = DateTime.now();
    final event = SafetyEvent(
      id: 'evt_fall_manual_${now.millisecondsSinceEpoch}',
      workerId: workerId,
      workerName: workerName,
      eventType: 'Fall Detection',
      severity: AppConstants.severityCritical,
      timestamp: now,
      worksiteId: _currentWorksiteId,
      description:
          'Manually simulated accelerometer impact event for $workerName.',
      dataSource: AppConstants.dataSourceSimulated,
    );

    final alert = Alert(
      id: 'alt_fall_manual_${now.millisecondsSinceEpoch}',
      title: 'Simulated Fall Event Triggered',
      message: 'Simulated fall detected for $workerName',
      severity: AppConstants.severityCritical,
      timestamp: now,
      worksiteId: _currentWorksiteId,
      alertType: 'Worker Safety',
      workerId: workerId,
      dataSource: AppConstants.dataSourceSimulated,
    );

    _eventStreamController.add(event);
    _alertStreamController.add(alert);
    notifyListeners();
  }

  void triggerTestSOS(String workerId, String workerName) {
    final now = DateTime.now();
    final event = SafetyEvent(
      id: 'evt_sos_${now.millisecondsSinceEpoch}',
      workerId: workerId,
      workerName: workerName,
      eventType: 'Test SOS',
      severity: AppConstants.severityCritical,
      timestamp: now,
      worksiteId: _currentWorksiteId,
      description:
          'Manual test SOS signal activated by $workerName. (Test Mode Only)',
      dataSource: AppConstants.dataSourceSimulated,
    );

    final alert = Alert(
      id: 'alt_sos_${now.millisecondsSinceEpoch}',
      title: 'TEST EMERGENCY SOS ACTIVATED',
      message:
          'Test SOS activated by $workerName in $_currentWorksiteId. No emergency services contacted.',
      severity: AppConstants.severityCritical,
      timestamp: now,
      worksiteId: _currentWorksiteId,
      alertType: 'Emergency',
      workerId: workerId,
      dataSource: AppConstants.dataSourceSimulated,
    );

    _eventStreamController.add(event);
    _alertStreamController.add(alert);
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _eventStreamController.close();
    _alertStreamController.close();
    super.dispose();
  }
}
