import '../models/worker.dart';
import '../models/asset.dart';
import '../models/alert.dart';
import '../models/safety_event.dart';
import '../models/sensor_reading.dart';

abstract class ISafetyDataSource {
  String get dataSourceName;

  Future<List<Worker>> getWorkers();
  Future<void> saveWorker(Worker worker);
  Future<void> deleteWorker(String id);

  Future<List<Asset>> getAssets();
  Future<void> saveAsset(Asset asset);
  Future<void> deleteAsset(String id);

  Future<List<Alert>> getAlerts();
  Future<void> saveAlert(Alert alert);
  Future<void> updateAlert(Alert alert);

  Future<List<SafetyEvent>> getEvents();
  Future<void> saveEvent(SafetyEvent event);

  Future<List<SensorReading>> getLatestSensorReadings(String worksiteId);
}
