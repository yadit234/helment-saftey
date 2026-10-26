-- MineGuard - Asset & Worker Safety System Database Migration
-- PostgreSQL / Supabase Schema

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. PROFILES TABLE
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    full_name TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'Worker',
    worksite_id TEXT,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. WORKSITES TABLE
CREATE TABLE IF NOT EXISTS public.worksites (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    location TEXT NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    status TEXT NOT NULL DEFAULT 'Active',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. WORKERS TABLE
CREATE TABLE IF NOT EXISTS public.workers (
    id TEXT PRIMARY KEY,
    worker_code TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    avatar_url TEXT,
    role TEXT NOT NULL,
    department TEXT NOT NULL,
    site_id TEXT REFERENCES public.worksites(id) ON DELETE SET NULL,
    worksite_name TEXT NOT NULL,
    contact_number TEXT NOT NULL,
    shift TEXT NOT NULL,
    is_checked_in BOOLEAN DEFAULT TRUE,
    safety_status TEXT DEFAULT 'Normal',
    emergency_contact_name TEXT NOT NULL,
    emergency_contact_phone TEXT NOT NULL,
    registration_date TIMESTAMPTZ DEFAULT NOW(),
    last_check_in TIMESTAMPTZ,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION
);

-- 4. ASSETS TABLE
CREATE TABLE IF NOT EXISTS public.assets (
    id TEXT PRIMARY KEY,
    asset_code TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    manufacturer TEXT NOT NULL,
    model TEXT NOT NULL,
    site_id TEXT REFERENCES public.worksites(id) ON DELETE SET NULL,
    worksite_name TEXT NOT NULL,
    assigned_operator TEXT,
    operational_status TEXT DEFAULT 'Operational',
    maintenance_status TEXT DEFAULT 'Good',
    last_inspection_date TIMESTAMPTZ NOT NULL,
    next_maintenance_date TIMESTAMPTZ NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. SENSOR READINGS TABLE (IoT & ESP32 Data Ingestion)
CREATE TABLE IF NOT EXISTS public.sensor_readings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    device_id TEXT NOT NULL,
    sensor_id TEXT NOT NULL,
    sensor_type TEXT NOT NULL,
    reading_value DOUBLE PRECISION NOT NULL,
    unit TEXT NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    worksite_id TEXT REFERENCES public.worksites(id) ON DELETE CASCADE,
    data_source TEXT DEFAULT 'ESP32 Hardware',
    connection_status TEXT DEFAULT 'Online'
);

-- Index on sensor_readings timestamp for rapid chart querying
CREATE INDEX IF NOT EXISTS idx_sensor_readings_time ON public.sensor_readings (timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_sensor_readings_site ON public.sensor_readings (worksite_id);

-- 6. SAFETY EVENTS TABLE
CREATE TABLE IF NOT EXISTS public.safety_events (
    id TEXT PRIMARY KEY,
    worker_id TEXT REFERENCES public.workers(id) ON DELETE SET NULL,
    worker_name TEXT,
    event_type TEXT NOT NULL,
    severity TEXT NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    worksite_id TEXT REFERENCES public.worksites(id) ON DELETE CASCADE,
    description TEXT NOT NULL,
    is_acknowledged BOOLEAN DEFAULT FALSE,
    is_resolved BOOLEAN DEFAULT FALSE,
    resolution_notes TEXT,
    data_source TEXT DEFAULT 'ESP32 Hardware'
);

-- 7. ALERTS TABLE
CREATE TABLE IF NOT EXISTS public.alerts (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    severity TEXT NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    worksite_id TEXT REFERENCES public.worksites(id) ON DELETE CASCADE,
    alert_type TEXT NOT NULL,
    worker_id TEXT REFERENCES public.workers(id) ON DELETE SET NULL,
    asset_id TEXT REFERENCES public.assets(id) ON DELETE SET NULL,
    is_acknowledged BOOLEAN DEFAULT FALSE,
    is_resolved BOOLEAN DEFAULT FALSE,
    resolution_notes TEXT,
    data_source TEXT DEFAULT 'ESP32 Hardware'
);

-- 8. MAINTENANCE RECORDS TABLE
CREATE TABLE IF NOT EXISTS public.maintenance_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    asset_id TEXT REFERENCES public.assets(id) ON DELETE CASCADE,
    performed_by TEXT NOT NULL,
    maintenance_type TEXT NOT NULL,
    notes TEXT,
    timestamp TIMESTAMPTZ DEFAULT NOW()
);

-- 9. ATTENDANCE RECORDS TABLE
CREATE TABLE IF NOT EXISTS public.attendance_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    worker_id TEXT REFERENCES public.workers(id) ON DELETE CASCADE,
    check_in_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    check_out_time TIMESTAMPTZ,
    worksite_id TEXT REFERENCES public.worksites(id)
);

-- ROW LEVEL SECURITY (RLS) POLICIES

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.worksites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sensor_readings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.safety_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.maintenance_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance_records ENABLE ROW LEVEL SECURITY;

-- Allow authenticated users to read worksites, workers, assets, sensor readings, alerts
CREATE POLICY "Authenticated users can read worksites" ON public.worksites FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can read workers" ON public.workers FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can read assets" ON public.assets FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can read sensor_readings" ON public.sensor_readings FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can read safety_events" ON public.safety_events FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can read alerts" ON public.alerts FOR SELECT TO authenticated USING (true);

-- Allow authenticated safety officers and admins to insert/update safety events & alerts
CREATE POLICY "Authenticated users can insert sensor_readings" ON public.sensor_readings FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can insert alerts" ON public.alerts FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update alerts" ON public.alerts FOR UPDATE TO authenticated USING (true);
