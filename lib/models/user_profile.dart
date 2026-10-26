class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final String
  role; // 'Administrator', 'Safety Officer', 'Site Supervisor', 'Worker'
  final String worksiteId;
  final String? avatarUrl;

  UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.worksiteId,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'fullName': fullName,
    'role': role,
    'worksiteId': worksiteId,
    'avatarUrl': avatarUrl,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    email: json['email'] as String,
    fullName: json['fullName'] as String,
    role: json['role'] as String,
    worksiteId: json['worksiteId'] as String,
    avatarUrl: json['avatarUrl'] as String?,
  );
}
