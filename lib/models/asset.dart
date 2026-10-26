class Asset {
  final String id;
  final String assetCode;
  final String name;
  final String category;
  final String manufacturer;
  final String model;
  final String siteId;
  final String worksiteName;
  final String? assignedOperator;
  final String
  operationalStatus; // 'Operational', 'Maintenance Required', 'Out of Service'
  final String maintenanceStatus; // 'Good', 'Due Soon', 'Overdue'
  final DateTime lastInspectionDate;
  final DateTime nextMaintenanceDate;
  final double latitude;
  final double longitude;
  final String notes;

  Asset({
    required this.id,
    required this.assetCode,
    required this.name,
    required this.category,
    required this.manufacturer,
    required this.model,
    required this.siteId,
    required this.worksiteName,
    this.assignedOperator,
    this.operationalStatus = 'Operational',
    this.maintenanceStatus = 'Good',
    required this.lastInspectionDate,
    required this.nextMaintenanceDate,
    required this.latitude,
    required this.longitude,
    this.notes = '',
  });

  Asset copyWith({
    String? id,
    String? assetCode,
    String? name,
    String? category,
    String? manufacturer,
    String? model,
    String? siteId,
    String? worksiteName,
    String? assignedOperator,
    String? operationalStatus,
    String? maintenanceStatus,
    DateTime? lastInspectionDate,
    DateTime? nextMaintenanceDate,
    double? latitude,
    double? longitude,
    String? notes,
  }) {
    return Asset(
      id: id ?? this.id,
      assetCode: assetCode ?? this.assetCode,
      name: name ?? this.name,
      category: category ?? this.category,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      siteId: siteId ?? this.siteId,
      worksiteName: worksiteName ?? this.worksiteName,
      assignedOperator: assignedOperator ?? this.assignedOperator,
      operationalStatus: operationalStatus ?? this.operationalStatus,
      maintenanceStatus: maintenanceStatus ?? this.maintenanceStatus,
      lastInspectionDate: lastInspectionDate ?? this.lastInspectionDate,
      nextMaintenanceDate: nextMaintenanceDate ?? this.nextMaintenanceDate,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'assetCode': assetCode,
    'name': name,
    'category': category,
    'manufacturer': manufacturer,
    'model': model,
    'siteId': siteId,
    'worksiteName': worksiteName,
    'assignedOperator': assignedOperator,
    'operationalStatus': operationalStatus,
    'maintenanceStatus': maintenanceStatus,
    'lastInspectionDate': lastInspectionDate.toIso8601String(),
    'nextMaintenanceDate': nextMaintenanceDate.toIso8601String(),
    'latitude': latitude,
    'longitude': longitude,
    'notes': notes,
  };

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
    id: json['id'] as String,
    assetCode: json['assetCode'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    manufacturer: json['manufacturer'] as String,
    model: json['model'] as String,
    siteId: json['siteId'] as String,
    worksiteName: json['worksiteName'] as String,
    assignedOperator: json['assignedOperator'] as String?,
    operationalStatus: json['operationalStatus'] as String? ?? 'Operational',
    maintenanceStatus: json['maintenanceStatus'] as String? ?? 'Good',
    lastInspectionDate: DateTime.parse(json['lastInspectionDate'] as String),
    nextMaintenanceDate: DateTime.parse(json['nextMaintenanceDate'] as String),
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    notes: json['notes'] as String? ?? '',
  );
}
