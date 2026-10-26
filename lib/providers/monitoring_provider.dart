import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/safety_event.dart';
import '../repositories/monitoring_repository.dart';
import '../services/simulation_service.dart';

class MonitoringProvider extends ChangeNotifier {
  final MonitoringRepository repository;
  final SimulationService simulationService;

  List<SafetyEvent> _events = [];
  bool _isLoading = false;
  bool _sosActive = false;
  SafetyEvent? _activeSosEvent;

  StreamSubscription<SafetyEvent>? _eventSub;

  MonitoringProvider(this.repository, this.simulationService) {
    loadEvents();
    _listenToSimulation();
  }

  List<SafetyEvent> get events => _events;
  bool get isLoading => _isLoading;
  bool get sosActive => _sosActive;
  SafetyEvent? get activeSosEvent => _activeSosEvent;

  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();

    _events = await repository.getEvents();

    _isLoading = false;
    notifyListeners();
  }

  void _listenToSimulation() {
    _eventSub = simulationService.onSafetyEvent.listen((event) async {
      await repository.addEvent(event);
      _events.insert(0, event);
      if (_events.length > 50) _events.removeLast();

      if (event.eventType == 'Test SOS') {
        _sosActive = true;
        _activeSosEvent = event;
      }
      notifyListeners();
    });
  }

  void activateTestSOS(String workerId, String workerName) {
    simulationService.triggerTestSOS(workerId, workerName);
  }

  void resetTestSOS() {
    _sosActive = false;
    _activeSosEvent = null;
    notifyListeners();
  }

  void triggerFallDetection(String workerId, String workerName) {
    simulationService.triggerManualFallSimulation(workerId, workerName);
  }

  Future<void> acknowledgeEvent(String id) async {
    await repository.acknowledgeEvent(id);
    await loadEvents();
  }

  Future<void> resolveEvent(String id, String notes) async {
    await repository.resolveEvent(id, notes);
    await loadEvents();
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    super.dispose();
  }
}
