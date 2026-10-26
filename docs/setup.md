# MineGuard — Setup & Installation Guide

## Requirements
- Flutter SDK (3.13+ or higher)
- Dart SDK (3.1+ or higher)
- Android Studio / VS Code with Flutter extension
- Android Emulator or physical device

## Quick Start (Simulation / Demo Mode)

1. Clone or open the repository in Android Studio / VS Code:
   ```bash
   cd asset_worker_safety_system
   ```

2. Fetch Flutter packages:
   ```bash
   flutter pub get
   ```

3. Run static analysis:
   ```bash
   flutter analyze
   ```

4. Run unit tests:
   ```bash
   flutter test
   ```

5. Launch application on connected Android emulator/device:
   ```bash
   flutter run
   ```

The application launches directly into Local Demo Mode without needing physical hardware or external credentials.

## Optional Supabase Backend Setup
1. Create a Supabase project at [supabase.com](https://supabase.com).
2. Execute the SQL script in `supabase/migrations/01_initial_schema.sql` inside the Supabase SQL Editor.
3. Open the MineGuard app -> **Settings** -> enter your **Supabase URL** and **Anon Key**.
