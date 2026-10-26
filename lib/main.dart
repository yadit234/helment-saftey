import 'package:flutter/material.dart';

import 'app.dart';
import 'core/constants/app_constants.dart';
import 'services/storage_service.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Supabase with your credentials
    await SupabaseService.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  } catch (e) {
    debugPrint('Supabase initialization error: $e');
  }

  final storageService = StorageService();
  try {
    await storageService.init();
  } catch (e) {
    debugPrint('Storage service initialization error: $e');
  }

  runApp(MineGuardApp(storageService: storageService));
}
