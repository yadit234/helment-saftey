class SensorReading {
  final String id;
  final String deviceId;
  final String sensorId;
  final String sensorType; // 'Temperature', 'Gas', 'Humidity', 'Vibration'
  final double readingValue;
  final String unit; // '°C', 'ppm', '%', 'g'
  final DateTime timestamp;
  final String worksiteId;
  final String dataSource; // 'Simulated', 'ESP32 Hardware'
  final String connectionStatus; // 'Online', 'Offline', 'Simulated'

  SensorReading({
    required this.id,
    required this.deviceId,
    required this.sensorId,
    required this.sensorType,
    required this.readingValue,
    required this.unit,
    required this.timestamp,
    required this.worksiteId,
    this.dataSource = 'Simulated',
    this.connectionStatus = 'Simulated',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'deviceId': deviceId,
    'sensorId': sensorId,
    'sensorType': sensorType,
    'readingValue': readingValue,
    'unit': unit,
    'timestamp': timestamp.toIso8601String(),
    'worksiteId': worksiteId,
    'dataSource': dataSource,
    'connectionStatus': connectionStatus,
  };

  factory SensorReading.fromJson(Map<String, dynamic> json) => SensorReading(
    id: json['id'] as String,
    deviceId: json['deviceId'] as String,
    sensorId: json['sensorId'] as String,
    sensorType: json['sensorType'] as String,
    readingValue: (json['readingValue'] as num).toDouble(),
    unit: json['unit'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    worksiteId: json['worksiteId'] as String,
    dataSource: json['dataSource'] as String? ?? 'Simulated',
    connectionStatus: json['connectionStatus'] as String? ?? 'Simulated',
  );
}
