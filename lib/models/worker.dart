class Worker {
  final String id;
  final String workerCode;
  final String fullName;
  final String? avatarUrl;
  final String role;
  final String department;
  final String siteId;
  final String worksiteName;
  final String contactNumber;
  final String shift;
  final bool isCheckedIn;
  final String safetyStatus; // 'Normal', 'Warning', 'Critical', 'Fall Detected'
  final String emergencyContactName;
  final String emergencyContactPhone;
  final DateTime registrationDate;
  final DateTime? lastCheckIn;
  final double? latitude;
  final double? longitude;
  final int? heartRate; // Heart Rate in BPM (Pulse Sensor)

  Worker({
    required this.id,
    required this.workerCode,
    required this.fullName,
    this.avatarUrl,
    required this.role,
    required this.department,
    required this.siteId,
    required this.worksiteName,
    required this.contactNumber,
    required this.shift,
    this.isCheckedIn = true,
    this.safetyStatus = 'Normal',
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.registrationDate,
    this.lastCheckIn,
    this.latitude,
    this.longitude,
    this.heartRate = 75,
  });

  Worker copyWith({
    String? id,
    String? workerCode,
    String? fullName,
    String? avatarUrl,
    String? role,
    String? department,
    String? siteId,
    String? worksiteName,
    String? contactNumber,
    String? shift,
    bool? isCheckedIn,
    String? safetyStatus,
    String? emergencyContactName,
    String? emergencyContactPhone,
    DateTime? registrationDate,
    DateTime? lastCheckIn,
    double? latitude,
    double? longitude,
    int? heartRate,
  }) {
    return Worker(
      id: id ?? this.id,
      workerCode: workerCode ?? this.workerCode,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      department: department ?? this.department,
      siteId: siteId ?? this.siteId,
      worksiteName: worksiteName ?? this.worksiteName,
      contactNumber: contactNumber ?? this.contactNumber,
      shift: shift ?? this.shift,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      safetyStatus: safetyStatus ?? this.safetyStatus,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      registrationDate: registrationDate ?? this.registrationDate,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      heartRate: heartRate ?? this.heartRate,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'workerCode': workerCode,
    'fullName': fullName,
    'avatarUrl': avatarUrl,
    'role': role,
    'department': department,
    'siteId': siteId,
    'worksiteName': worksiteName,
    'contactNumber': contactNumber,
    'shift': shift,
    'isCheckedIn': isCheckedIn,
    'safetyStatus': safetyStatus,
    'emergencyContactName': emergencyContactName,
    'emergencyContactPhone': emergencyContactPhone,
    'registrationDate': registrationDate.toIso8601String(),
    'lastCheckIn': lastCheckIn?.toIso8601String(),
    'latitude': latitude,
    'longitude': longitude,
    'heartRate': heartRate,
  };

  factory Worker.fromJson(Map<String, dynamic> json) => Worker(
    id: json['id'] as String,
    workerCode: json['workerCode'] as String,
    fullName: json['fullName'] as String,
    avatarUrl: json['avatarUrl'] as String?,
    role: json['role'] as String,
    department: json['department'] as String,
    siteId: json['siteId'] as String,
    worksiteName: json['worksiteName'] as String,
    contactNumber: json['contactNumber'] as String,
    shift: json['shift'] as String,
    isCheckedIn: json['isCheckedIn'] as bool? ?? true,
    safetyStatus: json['safetyStatus'] as String? ?? 'Normal',
    emergencyContactName: json['emergencyContactName'] as String,
    emergencyContactPhone: json['emergencyContactPhone'] as String,
    registrationDate: DateTime.parse(json['registrationDate'] as String),
    lastCheckIn: json['lastCheckIn'] != null
        ? DateTime.parse(json['lastCheckIn'] as String)
        : null,
    latitude: json['latitude'] != null
        ? (json['latitude'] as num).toDouble()
        : null,
    longitude: json['longitude'] != null
        ? (json['longitude'] as num).toDouble()
        : null,
    heartRate: json['heartRate'] as int? ?? 75,
  );
}
