# MineGuard — Future ESP32 & Hardware Integration Architecture

## Overview
This document outlines how to transition MineGuard from local simulation mode to physical hardware telemetry powered by ESP32 microcontrollers and industrial sensors.

## Hardware Components (Future Deployment)
- **Controller**: ESP32 NodeMCU (Wi-Fi + Bluetooth + Accelerometer SPI/I2C)
- **Temperature & Humidity**: DHT22 or SHT31 sensor
- **Gas Detection**: MQ-135 or MQ-4 gas sensor
- **Fall Detection**: MPU-6050 6-axis Gyroscope & Accelerometer
- **GPS Location**: NEO-6M GPS Module
- **Emergency Panic Button**: Tactile Push Button interrupt pin

## Firmware Architecture (Arduino IDE / C++)

1. **Hardware Pin Mapping**:
   - `DHT22_PIN` -> GPIO 4
   - `MQ135_PIN` -> GPIO 34 (ADC)
   - `MPU6050_SDA/SCL` -> GPIO 21 / 22
   - `SOS_BUTTON_PIN` -> GPIO 15 (Interrupt)

2. **Ingestion API Request Payload**:
   ```json
   {
     "device_id": "ESP32_SITE_ALPHA_01",
     "sensor_id": "MQ135_GAS",
     "sensor_type": "Gas",
     "reading_value": 450.0,
     "unit": "ppm",
     "timestamp": "2026-10-18T12:00:00Z",
     "worksite_id": "site_alpha",
     "data_source": "ESP32 Hardware"
   }
   ```

3. **Backend Communication**:
   The ESP32 firmware posts telemetry over HTTPS directly to Supabase REST endpoints (`/rest/v1/sensor_readings`) or through an MQTT broker bridge using client API keys.

4. **Switching MineGuard Flutter Client to Real Hardware**:
   In `SettingsScreen`, input your live Supabase credentials. MineGuard will automatically query the `sensor_readings`, `safety_events`, and `alerts` PostgreSQL tables instead of generating simulated values.
