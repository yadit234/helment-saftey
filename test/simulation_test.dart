import 'package:flutter_test/flutter_test.dart';
import 'package:asset_worker_safety_system/services/simulation_service.dart';
import 'package:asset_worker_safety_system/models/safety_event.dart';
import 'package:asset_worker_safety_system/models/alert.dart';

void main() {
  late SimulationService simService;

  setUp(() {
    simService = SimulationService();
    simService.pauseSimulation(); // Pause automatic timer during test
  });

  tearDown(() {
    simService.dispose();
  });

  test('SimulationService generates valid initial readings', () {
    expect(simService.currentTemperature.readingValue, greaterThan(0));
    expect(simService.currentGas.readingValue, greaterThan(0));
    expect(simService.currentHumidity.readingValue, greaterThan(0));
    expect(simService.currentVibration.readingValue, greaterThan(0));
    expect(simService.currentTemperature.dataSource, 'Simulated');
  });

  test('generateNextReading updates values and pushes to history', () {
    final initialHistoryCount = simService.temperatureHistory.length;
    simService.generateNextReading();
    expect(
      simService.temperatureHistory.length,
      equals(initialHistoryCount + 1),
    );
  });

  test('triggerTestSOS emits Test SOS SafetyEvent and Alert', () async {
    SafetyEvent? receivedEvent;
    Alert? receivedAlert;

    simService.onSafetyEvent.listen((event) {
      receivedEvent = event;
    });

    simService.onAlert.listen((alert) {
      receivedAlert = alert;
    });

    simService.triggerTestSOS('w_99', 'Test Worker');

    await Future.delayed(const Duration(milliseconds: 50));

    expect(receivedEvent, isNotNull);
    expect(receivedEvent?.eventType, equals('Test SOS'));
    expect(receivedEvent?.workerId, equals('w_99'));

    expect(receivedAlert, isNotNull);
    expect(receivedAlert?.alertType, equals('Emergency'));
  });

  test('triggerManualFallSimulation emits Fall Detection event', () async {
    SafetyEvent? receivedEvent;

    simService.onSafetyEvent.listen((event) {
      receivedEvent = event;
    });

    simService.triggerManualFallSimulation('w_88', 'John Fall Test');

    await Future.delayed(const Duration(milliseconds: 50));

    expect(receivedEvent, isNotNull);
    expect(receivedEvent?.eventType, equals('Fall Detection'));
    expect(receivedEvent?.workerName, equals('John Fall Test'));
  });
}
