class Alert {
  final String id;
  final String title;
  final String message;
  final String severity; // 'Critical', 'High', 'Warning', 'Info'
  final DateTime timestamp;
  final String worksiteId;
  final String
  alertType; // 'Environmental', 'Worker Safety', 'Equipment', 'Emergency'
  final String? workerId;
  final String? assetId;
  final bool isAcknowledged;
  final bool isResolved;
  final String? resolutionNotes;
  final String dataSource;

  Alert({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.timestamp,
    required this.worksiteId,
    required this.alertType,
    this.workerId,
    this.assetId,
    this.isAcknowledged = false,
    this.isResolved = false,
    this.resolutionNotes,
    this.dataSource = 'Simulated',
  });

  Alert copyWith({
    String? id,
    String? title,
    String? message,
    String? severity,
    DateTime? timestamp,
    String? worksiteId,
    String? alertType,
    String? workerId,
    String? assetId,
    bool? isAcknowledged,
    bool? isResolved,
    String? resolutionNotes,
    String? dataSource,
  }) {
    return Alert(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      severity: severity ?? this.severity,
      timestamp: timestamp ?? this.timestamp,
      worksiteId: worksiteId ?? this.worksiteId,
      alertType: alertType ?? this.alertType,
      workerId: workerId ?? this.workerId,
      assetId: assetId ?? this.assetId,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
      isResolved: isResolved ?? this.isResolved,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      dataSource: dataSource ?? this.dataSource,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'severity': severity,
    'timestamp': timestamp.toIso8601String(),
    'worksiteId': worksiteId,
    'alertType': alertType,
    'workerId': workerId,
    'assetId': assetId,
    'isAcknowledged': isAcknowledged,
    'isResolved': isResolved,
    'resolutionNotes': resolutionNotes,
    'dataSource': dataSource,
  };

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
    id: json['id'] as String,
    title: json['title'] as String,
    message: json['message'] as String,
    severity: json['severity'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    worksiteId: json['worksiteId'] as String,
    alertType: json['alertType'] as String,
    workerId: json['workerId'] as String?,
    assetId: json['assetId'] as String?,
    isAcknowledged: json['isAcknowledged'] as bool? ?? false,
    isResolved: json['isResolved'] as bool? ?? false,
    resolutionNotes: json['resolutionNotes'] as String?,
    dataSource: json['dataSource'] as String? ?? 'Simulated',
  );
}
