import '../models/worker.dart';
import '../services/storage_service.dart';

class WorkerRepository {
  final StorageService storageService;

  WorkerRepository(this.storageService);

  Future<List<Worker>> getWorkers() async {
    return await storageService.loadWorkers();
  }

  Future<void> addWorker(Worker worker) async {
    final list = await getWorkers();
    list.add(worker);
    await storageService.saveWorkers(list);
  }

  Future<void> updateWorker(Worker worker) async {
    final list = await getWorkers();
    final index = list.indexWhere((w) => w.id == worker.id);
    if (index != -1) {
      list[index] = worker;
      await storageService.saveWorkers(list);
    }
  }

  Future<void> deleteWorker(String id) async {
    final list = await getWorkers();
    list.removeWhere((w) => w.id == id);
    await storageService.saveWorkers(list);
  }

  Future<Worker?> getWorkerById(String id) async {
    final list = await getWorkers();
    try {
      return list.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }
}
