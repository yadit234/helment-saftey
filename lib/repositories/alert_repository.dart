import '../models/alert.dart';
import '../services/storage_service.dart';

class AlertRepository {
  final StorageService storageService;

  AlertRepository(this.storageService);

  Future<List<Alert>> getAlerts() async {
    return await storageService.loadAlerts();
  }

  Future<void> addAlert(Alert alert) async {
    final list = await getAlerts();
    list.insert(0, alert);
    if (list.length > 100) list.removeLast();
    await storageService.saveAlerts(list);
  }

  Future<void> updateAlert(Alert alert) async {
    final list = await getAlerts();
    final index = list.indexWhere((a) => a.id == alert.id);
    if (index != -1) {
      list[index] = alert;
      await storageService.saveAlerts(list);
    }
  }

  Future<void> acknowledgeAlert(String alertId) async {
    final list = await getAlerts();
    final index = list.indexWhere((a) => a.id == alertId);
    if (index != -1) {
      list[index] = list[index].copyWith(isAcknowledged: true);
      await storageService.saveAlerts(list);
    }
  }

  Future<void> resolveAlert(String alertId, String notes) async {
    final list = await getAlerts();
    final index = list.indexWhere((a) => a.id == alertId);
    if (index != -1) {
      list[index] = list[index].copyWith(
        isAcknowledged: true,
        isResolved: true,
        resolutionNotes: notes,
      );
      await storageService.saveAlerts(list);
    }
  }
}
