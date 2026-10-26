import '../models/worksite.dart';
import '../services/storage_service.dart';

class WorksiteRepository {
  final StorageService storageService;

  WorksiteRepository(this.storageService);

  Future<List<Worksite>> getWorksites() async {
    return await storageService.loadWorksites();
  }

  Future<void> saveWorksites(List<Worksite> worksites) async {
    await storageService.saveWorksites(worksites);
  }
}
