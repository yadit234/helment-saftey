# MineGuard — Asset & Worker Safety System

MineGuard is a modern, responsive, industrial safety mobile application designed for mining operations and construction sites. It provides real-time environmental monitoring, worker safety management, heavy equipment asset tracking, fall detection event logging, and emergency SOS workflows.

---

## Key Features

1. **Comprehensive Dashboard**: Live summaries for total/on-duty workers, asset operational statuses, temperature/gas/humidity/vibration readings, active safety alerts, and real-time trend charts.
2. **Centralized Simulation Engine**: Operates without physical hardware. Periodically updates simulated environmental metrics (Temperature, Gas PPM, Humidity, Vibration) every 1–5 seconds and evaluates safety thresholds.
3. **Worker Management**: Comprehensive worker directory with search, site/role/status filters, worker detail views, check-in toggles, and add/edit/delete CRUD workflows.
4. **Asset & Equipment Tracking**: Industry equipment registry (Excavators, Cranes, Loaders, Haul Trucks, Rigs) with maintenance inspection schedules and operational status updates.
5. **Worker Safety & Fall Detection**: Real-time fall detection simulation, inactivity alerts, safety event timeline, event resolution dialogs, and acknowledgment workflows.
6. **Emergency SOS Module**: Prominent emergency interface with confirmation modal, active test SOS indicator, reset capability, and clear disclaimers that test mode does not contact real emergency services.
7. **Alert Management**: Filter alerts by severity (Critical, High, Warning, Info) or status (Active, Acknowledged, Resolved), search messages, and resolve alerts with investigation notes.
8. **Interactive Site Map**: OpenStreetMap integration via `flutter_map` showing worksite HQ, worker positions, asset locations, and callout detail cards.
9. **Reports & Analytics**: Daily executive safety summaries, date pickers, and downloadable CSV report log preview generation.
10. **Offline First & SharedPreferences Persistence**: Works completely offline out-of-the-box with local seed data and persistent SharedPreferences storage.
11. **Supabase & ESP32 Integration Ready**: Full PostgreSQL schema migrations (`supabase/migrations/01_initial_schema.sql`) and hardware integration architecture (`docs/esp32_integration.md`).

---

## Technology Stack

- **Frontend**: Flutter (3.13+) / Dart (3.1+)
- **Design System**: Material 3 (Forest Green `#176B52`, Teal `#00897B`, Mint Accent, Off-White `#F4F7F6`)
- **State Management**: Provider (`MultiProvider`, `ChangeNotifierProxyProvider`)
- **Local Storage**: SharedPreferences
- **Data Visualization**: `fl_chart`
- **Mapping**: `flutter_map` & `latlong2`
- **Backend & Database**: Supabase Flutter SDK & PostgreSQL RLS
- **Future IoT Hardware**: ESP32 NodeMCU, DHT22, MQ-135, MPU-6050

---

## Project Architecture

```
lib/
├── app.dart                        # MultiProvider setup & MaterialApp
├── main.dart                       # Entry point & StorageService init
├── core/
│   ├── constants/                  # AppColors & AppConstants
│   ├── theme/                      # Material 3 AppTheme
│   └── utils/                      # DateFormatter & helpers
├── models/                         # Worker, Asset, SensorReading, SafetyEvent, Alert, Worksite, UserProfile
├── services/                       # SimulationService, StorageService, SupabaseService, NotificationService
├── repositories/                   # WorkerRepo, AssetRepo, AlertRepo, MonitoringRepo, WorksiteRepo
├── providers/                      # DashboardProvider, WorkerProvider, AssetProvider, AlertProvider, MonitoringProvider, AuthProvider
├── widgets/                        # MetricCard, AlertCard, SimulationBanner, StatusBadge, EmptyState
└── screens/
    ├── main_navigation_screen.dart # Bottom Nav + Drawer (All 8 main sections)
    ├── dashboard/                  # DashboardScreen
    ├── workers/                    # WorkerListScreen, WorkerDetailScreen, AddEditWorkerScreen
    ├── assets/                     # AssetListScreen, AssetDetailScreen, AddEditAssetScreen
    ├── monitoring/                 # LiveMonitoringScreen, WorkerSafetyScreen, EmergencySosScreen
    ├── alerts/                     # AlertListScreen
    ├── site_map/                   # SiteMapScreen
    ├── reports/                    # ReportsScreen
    ├── settings/                   # SettingsScreen
    └── authentication/             # LoginScreen
```

---

## Getting Started

### Prerequisites
- Flutter SDK (version 3.13 or higher)
- Dart SDK (version 3.1 or higher)
- Android Studio / VS Code with Flutter extension
- Android Emulator or physical device

### Installation & Execution

1. Clone or navigate to project directory:
   ```bash
   cd asset_worker_safety_system
   ```

2. Fetch dependencies:
   ```bash
   flutter pub get
   ```

3. Run static analysis:
   ```bash
   flutter analyze
   ```

4. Execute unit test suite:
   ```bash
   flutter test
   ```

5. Launch the application:
   ```bash
   flutter run
   ```

---

## Simulation Mode & Demonstration

The application defaults to **SIMULATION MODE**. No physical ESP32 hardware or cloud Supabase connection is required for demonstration.

- **SIMULATION MODE Banner**: Displayed prominently at the top of the dashboard and live monitoring screens.
- **Adjusting Simulation Speed**: Navigate to **Live Environmental Monitoring** -> select interval rate (1s, 2s, 3s, 5s).
- **Adjusting Warning Limits**: Navigate to **Settings** -> adjust Temperature and Gas Concentration limit sliders.
- **Triggering Fall Events**: Open worker profile or **Worker Safety Log** -> tap **Simulate Fall Event**.
- **Triggering Test SOS**: Open **Emergency SOS** -> tap the **TEST SOS** button and confirm.

---

## Supabase & Database Setup

1. Create a Supabase project at [supabase.com](https://supabase.com).
2. Execute the migration SQL script `supabase/migrations/01_initial_schema.sql` in the Supabase SQL Editor.
3. Open MineGuard -> **Settings** -> enter your **Supabase URL** and **Anon Key**.

---

## Future ESP32 Hardware Integration

See detailed hardware documentation in [`docs/esp32_integration.md`](docs/esp32_integration.md).
MineGuard defines the `ISafetyDataSource` interface contract to allow seamless transition between `SimulationDataSource` and live hardware telemetry (`SupabaseDataSource`).

---

## Known Limitations

- **Simulated Telemetry**: Sensor values and GPS coordinates are generated locally in software simulation mode.
- **Emergency SOS**: Test SOS activations create local test events only and do not dispatch external emergency calls.
