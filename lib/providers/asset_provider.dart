import 'package:flutter/foundation.dart';

import '../models/asset.dart';
import '../repositories/asset_repository.dart';

class AssetProvider extends ChangeNotifier {
  final AssetRepository repository;

  List<Asset> _assets = [];
  String _searchQuery = '';
  String _filterSiteId = 'All';
  String _filterCategory = 'All';
  String _filterStatus = 'All';
  bool _isLoading = false;

  AssetProvider(this.repository) {
    loadAssets();
  }

  List<Asset> get assets => _assets;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get filterSiteId => _filterSiteId;
  String get filterCategory => _filterCategory;
  String get filterStatus => _filterStatus;

  List<Asset> get filteredAssets {
    return _assets.where((asset) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          asset.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          asset.assetCode.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          asset.manufacturer.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesSite =
          _filterSiteId == 'All' || asset.siteId == _filterSiteId;
      final matchesCategory =
          _filterCategory == 'All' || asset.category == _filterCategory;
      final matchesStatus =
          _filterStatus == 'All' || asset.operationalStatus == _filterStatus;

      return matchesSearch && matchesSite && matchesCategory && matchesStatus;
    }).toList();
  }

  int get totalAssetsCount => _assets.length;
  int get operationalAssetsCount => _assets
      .where((a) => a.operationalStatus == 'Operational')
      .toList()
      .length;
  int get maintenanceAlertsCount =>
      _assets.where((a) => a.maintenanceStatus != 'Good').toList().length;

  Future<void> loadAssets() async {
    _isLoading = true;
    notifyListeners();

    _assets = await repository.getAssets();

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

  void setFilterCategory(String category) {
    _filterCategory = category;
    notifyListeners();
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  Future<void> addAsset(Asset asset) async {
    await repository.addAsset(asset);
    await loadAssets();
  }

  Future<void> updateAsset(Asset asset) async {
    await repository.updateAsset(asset);
    await loadAssets();
  }

  Future<void> deleteAsset(String id) async {
    await repository.deleteAsset(id);
    await loadAssets();
  }

  Future<void> toggleOperationalStatus(String assetId, String newStatus) async {
    final asset = _assets.firstWhere((a) => a.id == assetId);
    final updated = asset.copyWith(operationalStatus: newStatus);
    await repository.updateAsset(updated);
    await loadAssets();
  }
}
