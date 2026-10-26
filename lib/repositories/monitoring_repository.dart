import '../models/safety_event.dart';
import '../services/storage_service.dart';

class MonitoringRepository {
  final StorageService storageService;

  MonitoringRepository(this.storageService);

  Future<List<SafetyEvent>> getEvents() async {
    return await storageService.loadEvents();
  }

  Future<void> addEvent(SafetyEvent event) async {
    final list = await getEvents();
    list.insert(0, event);
    if (list.length > 100) list.removeLast();
    await storageService.saveEvents(list);
  }

  Future<void> acknowledgeEvent(String eventId) async {
    final list = await getEvents();
    final index = list.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      list[index] = list[index].copyWith(isAcknowledged: true);
      await storageService.saveEvents(list);
    }
  }

  Future<void> resolveEvent(String eventId, String notes) async {
    final list = await getEvents();
    final index = list.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      list[index] = list[index].copyWith(
        isAcknowledged: true,
        isResolved: true,
        resolutionNotes: notes,
      );
      await storageService.saveEvents(list);
    }
  }
}
