import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asset_worker_safety_system/app.dart';
import 'package:asset_worker_safety_system/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MineGuardApp smoke test renders Dashboard UI', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final storageService = StorageService();
    await storageService.init();

    await tester.pumpWidget(MineGuardApp(storageService: storageService));
    await tester.pumpAndSettle();

    expect(find.text('MineGuard'), findsAtLeast(1));
    expect(find.text('SIMULATION MODE'), findsAtLeast(1));
  });
}
