import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';
import '../core/constants/app_constants.dart';
import '../services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  UserProfile _currentUser = UserProfile(
    id: 'usr_demo_admin',
    email: 'admin@mineguard.io',
    fullName: 'Chief Safety Inspector',
    role: AppConstants.roleAdmin,
    worksiteId: 'site_alpha',
  );

  bool _isDemoMode = true;

  UserProfile get currentUser => _currentUser;
  bool get isDemoMode => _isDemoMode;
  String get currentRole => _currentUser.role;

  void switchRole(String newRole) {
    _currentUser = UserProfile(
      id: _currentUser.id,
      email: _currentUser.email,
      fullName: _currentUser.fullName,
      role: newRole,
      worksiteId: _currentUser.worksiteId,
      avatarUrl: _currentUser.avatarUrl,
    );
    notifyListeners();
  }

  void loginAsDemoUser(String role) {
    _isDemoMode = true;
    _currentUser = UserProfile(
      id: 'usr_demo_${role.toLowerCase().replaceAll(" ", "_")}',
      email: '${role.toLowerCase().replaceAll(" ", "")}@mineguard.io',
      fullName: 'Demo $role',
      role: role,
      worksiteId: 'site_alpha',
    );
    notifyListeners();
  }

  Future<bool> signInWithSupabase(String email, String password) async {
    final response = await SupabaseService.signIn(email, password);
    if (response?.user != null) {
      _isDemoMode = false;
      _currentUser = UserProfile(
        id: response!.user!.id,
        email: response.user!.email ?? email,
        fullName:
            response.user!.userMetadata?['full_name'] as String? ??
            'Authenticated User',
        role: AppConstants.roleSafetyOfficer,
        worksiteId: 'site_alpha',
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    SupabaseService.signOut();
    loginAsDemoUser(AppConstants.roleAdmin);
  }
}
