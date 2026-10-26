import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/worksite_provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';

import 'dashboard/dashboard_screen.dart';
import 'workers/worker_list_screen.dart';
import 'assets/asset_list_screen.dart';
import 'monitoring/live_monitoring_screen.dart';
import 'monitoring/worker_safety_screen.dart';
import 'monitoring/emergency_sos_screen.dart';
import 'alerts/alert_list_screen.dart';
import 'site_map/site_map_screen.dart';
import 'reports/reports_screen.dart';
import 'settings/settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _bottomNavPages = [
    const DashboardScreen(),
    const WorkerListScreen(),
    const AssetListScreen(),
    const LiveMonitoringScreen(),
    const AlertListScreen(),
  ];

  void _navigateToPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? AppColors.primaryDarkGreen
            : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? AppColors.primaryDarkGreen
              : AppColors.textPrimary,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.accentMint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () {
        Navigator.pop(context); // Close drawer
        _navigateToPage(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final worksiteProvider = Provider.of<WorksiteProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final pages = [
      ..._bottomNavPages,
      const WorkerSafetyScreen(),
      const EmergencySosScreen(),
      const SiteMapScreen(),
      const ReportsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.health_and_safety, size: 28),
            const SizedBox(width: 8),
            const Text('MineGuard'),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.shade800,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'SIM',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          // Worksite selector
          if (worksiteProvider.worksites.isNotEmpty)
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: worksiteProvider.worksites.any((ws) => ws.id == worksiteProvider.selectedWorksiteId)
                    ? worksiteProvider.selectedWorksiteId
                    : worksiteProvider.worksites.first.id,
                dropdownColor: AppColors.primaryDarkGreen,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (val) {
                  if (val != null) worksiteProvider.selectWorksite(val);
                },
                items: worksiteProvider.worksites
                    .map(
                      (ws) =>
                          DropdownMenuItem(value: ws.id, child: Text(ws.name)),
                    )
                    .toList(),
              ),
            ),
          const SizedBox(width: 8),
          // User role avatar popup
          PopupMenuButton<String>(
            tooltip: 'User Role Profile',
            icon: const CircleAvatar(
              backgroundColor: Colors.white24,
              radius: 16,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            onSelected: (role) {
              authProvider.switchRole(role);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Switched role to $role'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authProvider.currentUser.fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Role: ${authProvider.currentUser.role}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const Divider(),
                  ],
                ),
              ),
              ...AppConstants.allRoles.map(
                (role) => PopupMenuItem(
                  value: role,
                  child: Row(
                    children: [
                      Icon(
                        authProvider.currentUser.role == role
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: AppColors.primaryDarkGreen,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(role),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primaryDarkGreen,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.health_and_safety,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'MineGuard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Asset & Worker Safety System',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          authProvider.currentUser.role,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              index: 0,
            ),
            _buildDrawerItem(icon: Icons.people, title: 'Workers', index: 1),
            _buildDrawerItem(
              icon: Icons.precision_manufacturing,
              title: 'Assets & Equipment',
              index: 2,
            ),
            _buildDrawerItem(
              icon: Icons.sensors,
              title: 'Live Environmental Monitoring',
              index: 3,
            ),
            _buildDrawerItem(
              icon: Icons.add_alert,
              title: 'Alert Management',
              index: 4,
            ),
            const Divider(),
            _buildDrawerItem(
              icon: Icons.accessibility_new,
              title: 'Worker Safety Log',
              index: 5,
            ),
            _buildDrawerItem(icon: Icons.sos, title: 'Emergency SOS', index: 6),
            _buildDrawerItem(icon: Icons.map, title: 'Site Map', index: 7),
            _buildDrawerItem(
              icon: Icons.bar_chart,
              title: 'Reports & Analytics',
              index: 8,
            ),
            _buildDrawerItem(icon: Icons.settings, title: 'Settings', index: 9),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex < pages.length ? _currentIndex : 0,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex < 5 ? _currentIndex : 0,
        onTap: _navigateToPage,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryDarkGreen,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Workers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.precision_manufacturing_outlined),
            activeIcon: Icon(Icons.precision_manufacturing),
            label: 'Assets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors_outlined),
            activeIcon: Icon(Icons.sensors),
            label: 'Monitoring',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
        ],
      ),
    );
  }
}
