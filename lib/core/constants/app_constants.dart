class AppConstants {
  static const String appName = 'MineGuard';
  static const String appSubtitle = 'Asset & Worker Safety System';
  static const String appVersion = '1.0.0 (Prototype)';

  // Supabase Credentials
  static const String supabaseUrl = 'https://lgtbzvdfeedujcshyzvu.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxndGJ6dmRmZWVkdWpjc2h5enZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTIzMzUyNDIsImV4cCI6MjEwNzkxMTI0Mn0.NPlwfFcPr0BskuBPZo-thv0kGxnd5CQHQLuj85S2I5E';

  // Simulation Threshold Defaults
  static const double defaultMaxTemperature = 40.0; // Celsius
  static const double defaultMinTemperature = 10.0; // Celsius
  static const int defaultMaxGasPpm = 700; // Simulated PPM
  static const double defaultMaxVibration = 4.5; // g-force
  static const double defaultMinHumidity = 20.0; // %
  static const double defaultMaxHumidity = 85.0; // %
  static const int defaultMaxHeartRate = 120; // BPM (Tachycardia Limit)
  static const int defaultMinHeartRate = 50; // BPM (Bradycardia Limit)

  // User Roles
  static const String roleAdmin = 'Administrator';
  static const String roleSafetyOfficer = 'Safety Officer';
  static const String roleSupervisor = 'Site Supervisor';
  static const String roleWorker = 'Worker';

  static const List<String> allRoles = [
    roleAdmin,
    roleSafetyOfficer,
    roleSupervisor,
    roleWorker,
  ];

  // Worksite Names
  static const List<String> defaultWorksites = [
    'Alpha Shaft Pit 1',
    'Beta Underground Quarry',
    'Gamma Crushing Site',
    'Delta Construction Area',
  ];

  // Asset Categories
  static const List<String> assetCategories = [
    'Excavators',
    'Cranes',
    'Loaders',
    'Haul Trucks',
    'Drilling Rigs',
    'Generators',
    'Safety Gear',
  ];

  // Event & Alert Severities
  static const String severityCritical = 'Critical';
  static const String severityHigh = 'High';
  static const String severityWarning = 'Warning';
  static const String severityInfo = 'Info';

  // Data Sources
  static const String dataSourceSimulated = 'Simulated';
  static const String dataSourceHardware = 'ESP32 Hardware';
  static const String dataSourceManual = 'Manual Input';
}
