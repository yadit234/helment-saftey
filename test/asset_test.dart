import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asset_worker_safety_system/services/storage_service.dart';
import 'package:asset_worker_safety_system/repositories/asset_repository.dart';
import 'package:asset_worker_safety_system/providers/asset_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storageService;
  late AssetRepository assetRepo;
  late AssetProvider assetProvider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storageService = StorageService();
    await storageService.init();
    assetRepo = AssetRepository(storageService);
    assetProvider = AssetProvider(assetRepo);
    await assetProvider.loadAssets();
  });

  test('AssetProvider loads seeded assets', () {
    expect(assetProvider.assets.length, greaterThan(0));
    expect(assetProvider.totalAssetsCount, equals(assetProvider.assets.length));
  });

  test('Asset category filtering works correctly', () {
    assetProvider.setFilterCategory('Excavators');
    for (var a in assetProvider.filteredAssets) {
      expect(a.category, equals('Excavators'));
    }
  });

  test('Toggle operational status updates asset state', () async {
    final asset = assetProvider.assets.first;
    await assetProvider.toggleOperationalStatus(asset.id, 'Maintenance Required');

    final updated = assetProvider.assets.firstWhere((a) => a.id == asset.id);
    expect(updated.operationalStatus, equals('Maintenance Required'));
  });
}
