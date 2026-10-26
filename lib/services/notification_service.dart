import '../models/alert.dart';

class NotificationService {
  // Simple in-app notification & alert suppression engine
  final Set<String> _activeAlertHashes = {};

  bool isDuplicate(Alert alert) {
    final hash = '${alert.worksiteId}_${alert.alertType}_${alert.severity}';
    if (_activeAlertHashes.contains(hash)) {
      return true;
    }
    _activeAlertHashes.add(hash);
    return false;
  }

  void clearAlert(Alert alert) {
    final hash = '${alert.worksiteId}_${alert.alertType}_${alert.severity}';
    _activeAlertHashes.remove(hash);
  }

  void reset() {
    _activeAlertHashes.clear();
  }
}
