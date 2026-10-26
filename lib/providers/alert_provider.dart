import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/alert.dart';
import '../repositories/alert_repository.dart';
import '../services/simulation_service.dart';

class AlertProvider extends ChangeNotifier {
  final AlertRepository repository;
  final SimulationService simulationService;

  List<Alert> _alerts = [];
  String _filterSeverity = 'All';
  String _filterStatus = 'All'; // 'All', 'Active', 'Acknowledged', 'Resolved'
  String _searchQuery = '';
  bool _isLoading = false;

  StreamSubscription<Alert>? _alertSub;

  AlertProvider(this.repository, this.simulationService) {
    loadAlerts();
    _listenToSimulation();
  }

  List<Alert> get alerts => _alerts;
  bool get isLoading => _isLoading;
  String get filterSeverity => _filterSeverity;
  String get filterStatus => _filterStatus;
  String get searchQuery => _searchQuery;

  List<Alert> get filteredAlerts {
    return _alerts.where((alert) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          alert.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          alert.message.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesSeverity =
          _filterSeverity == 'All' || alert.severity == _filterSeverity;

      final matchesStatus =
          _filterStatus == 'All' ||
          (_filterStatus == 'Active' &&
              !alert.isResolved &&
              !alert.isAcknowledged) ||
          (_filterStatus == 'Acknowledged' &&
              alert.isAcknowledged &&
              !alert.isResolved) ||
          (_filterStatus == 'Resolved' && alert.isResolved);

      return matchesSearch && matchesSeverity && matchesStatus;
    }).toList();
  }

  int get activeAlertsCount =>
      _alerts.where((a) => !a.isResolved).toList().length;

  int get criticalAlertsCount => _alerts
      .where((a) => !a.isResolved && a.severity == 'Critical')
      .toList()
      .length;

  Future<void> loadAlerts() async {
    _isLoading = true;
    notifyListeners();

    _alerts = await repository.getAlerts();

    _isLoading = false;
    notifyListeners();
  }

  void _listenToSimulation() {
    _alertSub = simulationService.onAlert.listen((alert) async {
      await repository.addAlert(alert);
      _alerts.insert(0, alert);
      if (_alerts.length > 50) _alerts.removeLast();
      notifyListeners();
    });
  }

  void setFilterSeverity(String severity) {
    _filterSeverity = severity;
    notifyListeners();
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> acknowledgeAlert(String id) async {
    await repository.acknowledgeAlert(id);
    await loadAlerts();
  }

  Future<void> resolveAlert(String id, String notes) async {
    await repository.resolveAlert(id, notes);
    await loadAlerts();
  }

  @override
  void dispose() {
    _alertSub?.cancel();
    super.dispose();
  }
}
