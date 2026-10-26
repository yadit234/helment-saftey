class SafetyEvent {
  final String id;
  final String? workerId;
  final String? workerName;
  final String eventType; // 'Fall Detection', 'High Temperature', 'Gas Spike', 'Test SOS', 'Restricted Zone', 'Inactivity'
  final String severity; // 'Critical', 'High', 'Warning', 'Info'
  final DateTime timestamp;
  final String worksiteId;
  final String description;
  final bool isAcknowledged;
  final bool isResolved;
  final String? resolutionNotes;
  final String dataSource;

  SafetyEvent({
    required this.id,
    this.workerId,
    this.workerName,
    required this.eventType,
    required this.severity,
    required this.timestamp,
    required this.worksiteId,
    required this.description,
    this.isAcknowledged = false,
    this.isResolved = false,
    this.resolutionNotes,
    this.dataSource = 'Simulated',
  });

  SafetyEvent copyWith({
    String? id,
    String? workerId,
    String? workerName,
    String? eventType,
    String? severity,
    DateTime? timestamp,
    String? worksiteId,
    String? description,
    bool? isAcknowledged,
    bool? isResolved,
    String? resolutionNotes,
    String? dataSource,
  }) {
    return SafetyEvent(
      id: id ?? this.id,
      workerId: workerId ?? this.workerId,
      workerName: workerName ?? this.workerName,
      eventType: eventType ?? this.eventType,
      severity: severity ?? this.severity,
      timestamp: timestamp ?? this.timestamp,
      worksiteId: worksiteId ?? this.worksiteId,
      description: description ?? this.description,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
      isResolved: isResolved ?? this.isResolved,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      dataSource: dataSource ?? this.dataSource,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'workerId': workerId,
    'workerName': workerName,
    'eventType': eventType,
    'severity': severity,
    'timestamp': timestamp.toIso8601String(),
    'worksiteId': worksiteId,
    'description': description,
    'isAcknowledged': isAcknowledged,
    'isResolved': isResolved,
    'resolutionNotes': resolutionNotes,
    'dataSource': dataSource,
  };

  factory SafetyEvent.fromJson(Map<String, dynamic> json) => SafetyEvent(
    id: json['id'] as String,
    workerId: json['workerId'] as String?,
    workerName: json['workerName'] as String?,
    eventType: json['eventType'] as String,
    severity: json['severity'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    worksiteId: json['worksiteId'] as String,
    description: json['description'] as String,
    isAcknowledged: json['isAcknowledged'] as bool? ?? false,
    isResolved: json['isResolved'] as bool? ?? false,
    resolutionNotes: json['resolutionNotes'] as String?,
    dataSource: json['dataSource'] as String? ?? 'Simulated',
  );
}
