class Worksite {
  final String id;
  final String name;
  final String location;
  final double latitude;
  final double longitude;
  final String status;
  final int workerCount;

  Worksite({
    required this.id,
    required this.name,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.status = 'Active',
    this.workerCount = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
    'status': status,
    'workerCount': workerCount,
  };

  factory Worksite.fromJson(Map<String, dynamic> json) => Worksite(
    id: json['id'] as String,
    name: json['name'] as String,
    location: json['location'] as String,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    status: json['status'] as String? ?? 'Active',
    workerCount: json['workerCount'] as int? ?? 0,
  );
}
