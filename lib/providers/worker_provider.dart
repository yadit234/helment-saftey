import 'package:flutter/foundation.dart';

import '../models/worker.dart';
import '../repositories/worker_repository.dart';

class WorkerProvider extends ChangeNotifier {
  final WorkerRepository repository;

  List<Worker> _workers = [];
  String _searchQuery = '';
  String _filterSiteId = 'All';
  String _filterRole = 'All';
  String _filterStatus = 'All';
  bool _isLoading = false;

  WorkerProvider(this.repository) {
    loadWorkers();
  }

  List<Worker> get workers => _workers;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get filterSiteId => _filterSiteId;
  String get filterRole => _filterRole;
  String get filterStatus => _filterStatus;

  List<Worker> get filteredWorkers {
    return _workers.where((worker) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          worker.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          worker.workerCode.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          worker.department.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesSite =
          _filterSiteId == 'All' || worker.siteId == _filterSiteId;
      final matchesRole = _filterRole == 'All' || worker.role == _filterRole;
      final matchesStatus =
          _filterStatus == 'All' ||
          (_filterStatus == 'On Duty' && worker.isCheckedIn) ||
          (_filterStatus == 'Off Duty' && !worker.isCheckedIn) ||
          (_filterStatus == 'Alert' && worker.safetyStatus != 'Normal');

      return matchesSearch && matchesSite && matchesRole && matchesStatus;
    }).toList();
  }

  int get totalWorkersCount => _workers.length;
  int get onDutyWorkersCount =>
      _workers.where((w) => w.isCheckedIn).toList().length;
  int get alertWorkersCount =>
      _workers.where((w) => w.safetyStatus != 'Normal').toList().length;

  Future<void> loadWorkers() async {
    _isLoading = true;
    notifyListeners();

    _workers = await repository.getWorkers();

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterSite(String siteId) {
    _filterSiteId = siteId;
    notifyListeners();
  }

  void setFilterRole(String role) {
    _filterRole = role;
    notifyListeners();
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  Future<void> addWorker(Worker worker) async {
    await repository.addWorker(worker);
    await loadWorkers();
  }

  Future<void> updateWorker(Worker worker) async {
    await repository.updateWorker(worker);
    await loadWorkers();
  }

  Future<void> deleteWorker(String id) async {
    await repository.deleteWorker(id);
    await loadWorkers();
  }

  Future<void> toggleCheckIn(String workerId) async {
    final worker = _workers.firstWhere((w) => w.id == workerId);
    final updated = worker.copyWith(
      isCheckedIn: !worker.isCheckedIn,
      lastCheckIn: DateTime.now(),
    );
    await repository.updateWorker(updated);
    await loadWorkers();
  }

  Future<void> updateWorkerSafetyStatus(String workerId, String status) async {
    final index = _workers.indexWhere((w) => w.id == workerId);
    if (index != -1) {
      final updated = _workers[index].copyWith(safetyStatus: status);
      await repository.updateWorker(updated);
      await loadWorkers();
    }
  }
}
