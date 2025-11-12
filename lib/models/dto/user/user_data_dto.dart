class UserDataDto {
  final String? email;
  final String? schoolEmail;
  final String? userRole;
  final String? name;
  final String? nickName;
  final String? profilePictureUrl;
  final String? OAuthProvider;
  final String? studentId;
  final String? department;

  UserDataDto({
    this.email,
    this.schoolEmail,
    this.userRole,
    this.name,
    this.nickName,
    this.profilePictureUrl,
    this.OAuthProvider,
    this.studentId,
    this.department,
  });

  factory UserDataDto.fromJson(Map<String, dynamic> json) => UserDataDto(
    email: json['email'] as String?,
    schoolEmail: json['schoolEmail'] as String?,
    userRole: json['userRole'] as String?,
    name: json['name'] as String?,
    nickName: json['nickName'] as String?,
    profilePictureUrl: json['profilePictureUrl'] as String?,
    OAuthProvider: json['OAuthProvider'] as String?,
    studentId: json['studentId'] as String?,
    department: json['department'] as String?,
  );
}
