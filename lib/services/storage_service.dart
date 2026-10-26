import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/worker.dart';
import '../models/asset.dart';
import '../models/alert.dart';
import '../models/safety_event.dart';
import '../models/worksite.dart';

class StorageService {
  static const String _keyWorkers = 'mineguard_workers';
  static const String _keyAssets = 'mineguard_assets';
  static const String _keyAlerts = 'mineguard_alerts';
  static const String _keyEvents = 'mineguard_events';
  static const String _keyWorksites = 'mineguard_worksites';
  static const String _keySettings = 'mineguard_settings';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey(_keyWorkers)) {
      await seedInitialData();
    }
  }

  Future<void> seedInitialData() async {
    final now = DateTime.now();

    // Worksites
    final worksites = [
      Worksite(
        id: 'site_alpha',
        name: 'Alpha Shaft Pit 1',
        location: 'Sector 4, North Ridge',
        latitude: -1.286389,
        longitude: 36.817223,
        status: 'Active',
        workerCount: 12,
      ),
      Worksite(
        id: 'site_beta',
        name: 'Beta Underground Quarry',
        location: 'Tunnel B, Level -150m',
        latitude: -1.288500,
        longitude: 36.820000,
        status: 'Active',
        workerCount: 8,
      ),
      Worksite(
        id: 'site_gamma',
        name: 'Gamma Crushing Site',
        location: 'Processing Yard C',
        latitude: -1.284000,
        longitude: 36.815000,
        status: 'Active',
        workerCount: 6,
      ),
    ];

    // Workers
    final workers = [
      Worker(
        id: 'w_01',
        workerCode: 'MG-101',
        fullName: 'David K. Lawson',
        role: 'Mining Engineer',
        department: 'Operations',
        siteId: 'site_alpha',
        worksiteName: 'Alpha Shaft Pit 1',
        contactNumber: '+1 555-0192',
        shift: 'Morning (06:00 - 14:00)',
        isCheckedIn: true,
        safetyStatus: 'Normal',
        emergencyContactName: 'Sarah Lawson',
        emergencyContactPhone: '+1 555-0193',
        registrationDate: now.subtract(const Duration(days: 120)),
        lastCheckIn: now.subtract(const Duration(hours: 2)),
        latitude: -1.286400,
        longitude: 36.817200,
      ),
      Worker(
        id: 'w_02',
        workerCode: 'MG-102',
        fullName: 'Elena Rostova',
        role: 'Safety Technician',
        department: 'Health & Safety',
        siteId: 'site_alpha',
        worksiteName: 'Alpha Shaft Pit 1',
        contactNumber: '+1 555-0248',
        shift: 'Morning (06:00 - 14:00)',
        isCheckedIn: true,
        safetyStatus: 'Normal',
        emergencyContactName: 'Igor Rostov',
        emergencyContactPhone: '+1 555-0249',
        registrationDate: now.subtract(const Duration(days: 90)),
        lastCheckIn: now.subtract(const Duration(hours: 3)),
        latitude: -1.286450,
        longitude: 36.817300,
      ),
      Worker(
        id: 'w_03',
        workerCode: 'MG-103',
        fullName: 'Marcus Vance',
        role: 'Heavy Equipment Operator',
        department: 'Excavation',
        siteId: 'site_beta',
        worksiteName: 'Beta Underground Quarry',
        contactNumber: '+1 555-0311',
        shift: 'Evening (14:00 - 22:00)',
        isCheckedIn: true,
        safetyStatus: 'Normal',
        emergencyContactName: 'Clara Vance',
        emergencyContactPhone: '+1 555-0312',
        registrationDate: now.subtract(const Duration(days: 200)),
        lastCheckIn: now.subtract(const Duration(hours: 1)),
        latitude: -1.288510,
        longitude: 36.820050,
      ),
      Worker(
        id: 'w_04',
        workerCode: 'MG-104',
        fullName: 'Amina Mohamed',
        role: 'Geologist',
        department: 'Surveying',
        siteId: 'site_beta',
        worksiteName: 'Beta Underground Quarry',
        contactNumber: '+1 555-0422',
        shift: 'Morning (06:00 - 14:00)',
        isCheckedIn: true,
        safetyStatus: 'Normal',
        emergencyContactName: 'Tariq Mohamed',
        emergencyContactPhone: '+1 555-0423',
        registrationDate: now.subtract(const Duration(days: 45)),
        lastCheckIn: now.subtract(const Duration(hours: 4)),
        latitude: -1.288520,
        longitude: 36.820100,
      ),
      Worker(
        id: 'w_05',
        workerCode: 'MG-105',
        fullName: 'James O\'Connor',
        role: 'Drill Master',
        department: 'Drilling',
        siteId: 'site_gamma',
        worksiteName: 'Gamma Crushing Site',
        contactNumber: '+1 555-0588',
        shift: 'Night (22:00 - 06:00)',
        isCheckedIn: false,
        safetyStatus: 'Normal',
        emergencyContactName: 'Mary O\'Connor',
        emergencyContactPhone: '+1 555-0589',
        registrationDate: now.subtract(const Duration(days: 300)),
        lastCheckIn: now.subtract(const Duration(hours: 14)),
        latitude: -1.284020,
        longitude: 36.815020,
      ),
    ];

    // Assets
    final assets = [
      Asset(
        id: 'a_01',
        assetCode: 'EQ-EXC-01',
        name: 'CAT 349 Hydraulic Excavator',
        category: 'Excavators',
        manufacturer: 'Caterpillar',
        model: '349FL',
        siteId: 'site_alpha',
        worksiteName: 'Alpha Shaft Pit 1',
        assignedOperator: 'Marcus Vance',
        operationalStatus: 'Operational',
        maintenanceStatus: 'Good',
        lastInspectionDate: now.subtract(const Duration(days: 10)),
        nextMaintenanceDate: now.add(const Duration(days: 20)),
        latitude: -1.286390,
        longitude: 36.817210,
        notes:
            'Operational at main pit zone. Hydraulic fluid changed last week.',
      ),
      Asset(
        id: 'a_02',
        assetCode: 'EQ-CRN-02',
        name: 'Liebherr LTM 1250 Mobile Crane',
        category: 'Cranes',
        manufacturer: 'Liebherr',
        model: 'LTM 1250-5.1',
        siteId: 'site_gamma',
        worksiteName: 'Gamma Crushing Site',
        assignedOperator: 'David K. Lawson',
        operationalStatus: 'Operational',
        maintenanceStatus: 'Due Soon',
        lastInspectionDate: now.subtract(const Duration(days: 25)),
        nextMaintenanceDate: now.add(const Duration(days: 5)),
        latitude: -1.284050,
        longitude: 36.815050,
        notes: 'Scheduled for load test inspection next Tuesday.',
      ),
      Asset(
        id: 'a_03',
        assetCode: 'EQ-DRL-03',
        name: 'Sandvik DI550 Surface Drill Rig',
        category: 'Drilling Rigs',
        manufacturer: 'Sandvik',
        model: 'DI550',
        siteId: 'site_beta',
        worksiteName: 'Beta Underground Quarry',
        assignedOperator: 'James O\'Connor',
        operationalStatus: 'Maintenance Required',
        maintenanceStatus: 'Overdue',
        lastInspectionDate: now.subtract(const Duration(days: 45)),
        nextMaintenanceDate: now.subtract(const Duration(days: 5)),
        latitude: -1.288530,
        longitude: 36.820080,
        notes: 'Drill bit vibration excessive. Maintenance flag set.',
      ),
      Asset(
        id: 'a_04',
        assetCode: 'EQ-TRK-04',
        name: 'Komatsu HD785 Haul Truck',
        category: 'Haul Trucks',
        manufacturer: 'Komatsu',
        model: 'HD785-7',
        siteId: 'site_alpha',
        worksiteName: 'Alpha Shaft Pit 1',
        assignedOperator: null,
        operationalStatus: 'Operational',
        maintenanceStatus: 'Good',
        lastInspectionDate: now.subtract(const Duration(days: 5)),
        nextMaintenanceDate: now.add(const Duration(days: 30)),
        latitude: -1.286420,
        longitude: 36.817250,
        notes: 'Tire pressures verified and normal.',
      ),
    ];

    // Initial Alerts
    final alerts = [
      Alert(
        id: 'alt_01',
        title: 'Overdue Equipment Maintenance',
        message: 'Sandvik DI550 Drill Rig (EQ-DRL-03) maintenance is overdue by 5 days.',
        severity: 'High',
        timestamp: now.subtract(const Duration(hours: 4)),
        worksiteId: 'site_beta',
        alertType: 'Equipment',
        assetId: 'a_03',
        isAcknowledged: false,
        isResolved: false,
        dataSource: 'Simulated',
      ),
      Alert(
        id: 'alt_02',
        title: 'High Temperature Threshold Alert',
        message: 'Temperature exceeded 40°C in Beta Underground Quarry.',
        severity: 'Warning',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 30)),
        worksiteId: 'site_beta',
        alertType: 'Environmental',
        isAcknowledged: true,
        isResolved: false,
        dataSource: 'Simulated',
      ),
    ];

    // Initial Safety Events
    final events = [
      SafetyEvent(
        id: 'evt_01',
        eventType: 'High Temperature',
        severity: 'Warning',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 30)),
        worksiteId: 'site_beta',
        description: 'Simulated ambient temperature reached 41.2°C.',
        isAcknowledged: true,
        isResolved: false,
        dataSource: 'Simulated',
      ),
    ];

    await saveWorksites(worksites);
    await saveWorkers(workers);
    await saveAssets(assets);
    await saveAlerts(alerts);
    await saveEvents(events);
  }

  // Worksites
  Future<List<Worksite>> loadWorksites() async {
    final str = _prefs.getString(_keyWorksites);
    if (str == null) return [];
    final List<dynamic> list = jsonDecode(str);
    return list
        .map((e) => Worksite.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveWorksites(List<Worksite> worksites) async {
    final str = jsonEncode(worksites.map((e) => e.toJson()).toList());
    await _prefs.setString(_keyWorksites, str);
  }

  // Workers
  Future<List<Worker>> loadWorkers() async {
    final str = _prefs.getString(_keyWorkers);
    if (str == null) return [];
    final List<dynamic> list = jsonDecode(str);
    return list.map((e) => Worker.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveWorkers(List<Worker> workers) async {
    final str = jsonEncode(workers.map((e) => e.toJson()).toList());
    await _prefs.setString(_keyWorkers, str);
  }

  // Assets
  Future<List<Asset>> loadAssets() async {
    final str = _prefs.getString(_keyAssets);
    if (str == null) return [];
    final List<dynamic> list = jsonDecode(str);
    return list.map((e) => Asset.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveAssets(List<Asset> assets) async {
    final str = jsonEncode(assets.map((e) => e.toJson()).toList());
    await _prefs.setString(_keyAssets, str);
  }

  // Alerts
  Future<List<Alert>> loadAlerts() async {
    final str = _prefs.getString(_keyAlerts);
    if (str == null) return [];
    final List<dynamic> list = jsonDecode(str);
    return list.map((e) => Alert.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveAlerts(List<Alert> alerts) async {
    final str = jsonEncode(alerts.map((e) => e.toJson()).toList());
    await _prefs.setString(_keyAlerts, str);
  }

  // Events
  Future<List<SafetyEvent>> loadEvents() async {
    final str = _prefs.getString(_keyEvents);
    if (str == null) return [];
    final List<dynamic> list = jsonDecode(str);
    return list
        .map((e) => SafetyEvent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveEvents(List<SafetyEvent> events) async {
    final str = jsonEncode(events.map((e) => e.toJson()).toList());
    await _prefs.setString(_keyEvents, str);
  }

  // Threshold Settings
  Map<String, dynamic> loadSettings() {
    final str = _prefs.getString(_keySettings);
    if (str == null) return {};
    return jsonDecode(str) as Map<String, dynamic>;
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _prefs.setString(_keySettings, jsonEncode(settings));
  }
}
