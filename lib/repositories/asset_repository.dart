import '../models/asset.dart';
import '../services/storage_service.dart';

class AssetRepository {
  final StorageService storageService;

  AssetRepository(this.storageService);

  Future<List<Asset>> getAssets() async {
    return await storageService.loadAssets();
  }

  Future<void> addAsset(Asset asset) async {
    final list = await getAssets();
    list.add(asset);
    await storageService.saveAssets(list);
  }

  Future<void> updateAsset(Asset asset) async {
    final list = await getAssets();
    final index = list.indexWhere((a) => a.id == asset.id);
    if (index != -1) {
      list[index] = asset;
      await storageService.saveAssets(list);
    }
  }

  Future<void> deleteAsset(String id) async {
    final list = await getAssets();
    list.removeWhere((a) => a.id == id);
    await storageService.saveAssets(list);
  }

  Future<Asset?> getAssetById(String id) async {
    final list = await getAssets();
    try {
      return list.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
