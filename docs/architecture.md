# MineGuard — System Architecture Documentation

## Overview
MineGuard is an industrial asset and worker safety application designed for mining and construction environments. It provides real-time simulation, environmental monitoring, asset tracking, fall detection event handling, and emergency SOS workflows.

## Layered Architecture

```
+-------------------------------------------------------------------+
|                        PRESENTATION LAYER                         |
|   Screens (Dashboard, Workers, Assets, Live Monitoring, Alerts,   |
|            Site Map, Reports, Settings, Emergency SOS)            |
|   Widgets (MetricCard, AlertCard, SimulationBanner, StatusBadge)  |
+-------------------------------------------------------------------+
                                  |
+-------------------------------------------------------------------+
|                       STATE MANAGEMENT LAYER                      |
|   Provider Pattern (DashboardProvider, WorkerProvider,           |
|   AssetProvider, AlertProvider, MonitoringProvider, AuthProvider) |
+-------------------------------------------------------------------+
                                  |
+-------------------------------------------------------------------+
|                         REPOSITORY LAYER                          |
|   WorkerRepository, AssetRepository, AlertRepository,             |
|   MonitoringRepository, WorksiteRepository                        |
+-------------------------------------------------------------------+
                                  |
+-------------------------------------------------------------------+
|                          SERVICES LAYER                           |
|   SimulationService (Centralized periodic sensor generation)      |
|   StorageService (Local SharedPreferences persistence)            |
|   SupabaseService (Cloud database & authentication wrapper)       |
|   NotificationService (Duplicate alert suppression filter)        |
+-------------------------------------------------------------------+
```

## Centralized Sensor Simulation
The `SimulationService` generates periodic telemetry updates (temperature, gas PPM, humidity, vibration) every 1–5 seconds. It evaluates configurable safety threshold limits and dispatches alerts and safety events using Dart `StreamController` broadcasts.

## Extensible Data Source Pattern
The system defines the `ISafetyDataSource` interface contract to allow swapping between local simulation data sources (`SimulationDataSource`) and real physical hardware ingestion (`SupabaseDataSource`).
