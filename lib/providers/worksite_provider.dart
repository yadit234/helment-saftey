import 'package:flutter/foundation.dart';

import '../models/worksite.dart';
import '../repositories/worksite_repository.dart';

class WorksiteProvider extends ChangeNotifier {
  final WorksiteRepository repository;

  List<Worksite> _worksites = [];
  String _selectedWorksiteId = 'site_alpha';
  bool _isLoading = false;

  WorksiteProvider(this.repository) {
    loadWorksites();
  }

  List<Worksite> get worksites => _worksites;
  String get selectedWorksiteId => _selectedWorksiteId;
  bool get isLoading => _isLoading;

  Worksite get selectedWorksite {
    return _worksites.firstWhere(
      (w) => w.id == _selectedWorksiteId,
      orElse: () => _worksites.isNotEmpty
          ? _worksites.first
          : Worksite(
              id: 'site_alpha',
              name: 'Alpha Shaft Pit 1',
              location: 'Sector 4',
              latitude: -1.286389,
              longitude: 36.817223,
            ),
    );
  }

  Future<void> loadWorksites() async {
    _isLoading = true;
    notifyListeners();

    _worksites = await repository.getWorksites();

    _isLoading = false;
    notifyListeners();
  }

  void selectWorksite(String id) {
    _selectedWorksiteId = id;
    notifyListeners();
  }
}
