import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asset_worker_safety_system/models/worker.dart';
import 'package:asset_worker_safety_system/services/storage_service.dart';
import 'package:asset_worker_safety_system/repositories/worker_repository.dart';
import 'package:asset_worker_safety_system/providers/worker_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storageService;
  late WorkerRepository workerRepo;
  late WorkerProvider workerProvider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storageService = StorageService();
    await storageService.init();
    workerRepo = WorkerRepository(storageService);
    workerProvider = WorkerProvider(workerRepo);
    await workerProvider.loadWorkers();
  });

  test('WorkerProvider loads seeded workers', () {
    expect(workerProvider.workers.length, greaterThan(0));
    expect(
      workerProvider.totalWorkersCount,
      equals(workerProvider.workers.length),
    );
  });

  test('Worker search filtering works correctly', () {
    workerProvider.setSearchQuery('Lawson');
    expect(workerProvider.filteredWorkers.length, equals(1));
    expect(workerProvider.filteredWorkers.first.fullName, contains('Lawson'));
  });

  test('Worker check-in toggle updates worker state', () async {
    final initialWorker = workerProvider.workers.first;
    final initialCheckIn = initialWorker.isCheckedIn;

    await workerProvider.toggleCheckIn(initialWorker.id);

    final updatedWorker = workerProvider.workers.firstWhere(
      (w) => w.id == initialWorker.id,
    );
    expect(updatedWorker.isCheckedIn, equals(!initialCheckIn));
  });

  test('Add worker increases worker list count', () async {
    final initialCount = workerProvider.totalWorkersCount;
    final newWorker = Worker(
      id: 'w_test_new',
      workerCode: 'MG-TEST',
      fullName: 'Test Worker Name',
      role: 'Mining Engineer',
      department: 'Testing',
      siteId: 'site_alpha',
      worksiteName: 'Alpha Site',
      contactNumber: '12345678',
      shift: 'Morning',
      emergencyContactName: 'Contact Name',
      emergencyContactPhone: '87654321',
      registrationDate: DateTime.now(),
    );

    await workerProvider.addWorker(newWorker);
    expect(workerProvider.totalWorkersCount, equals(initialCount + 1));
  });
}
