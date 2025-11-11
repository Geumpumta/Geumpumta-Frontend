class UserDataDto {
  final String email;
  final String schoolEmail;
  final String userRole;
  final String name;
  final String nickName;
  final String profilePictureUrl;
  final String OAuthProvider;
  final String studentId;
  final String department;

  UserDataDto({
    required this.email,
    required this.schoolEmail,
    required this.userRole,
    required this.name,
    required this.nickName,
    required this.profilePictureUrl,
    required this.OAuthProvider,
    required this.studentId,
    required this.department,
  });

  factory UserDataDto.fromJson(Map<String, dynamic> json)=>
      UserDataDto(
          email: json['email'],
          schoolEmail: json['schoolEmail'],
          userRole: json['userRole'],
          name: json['name'],
          nickName: json['nickName'],
          profilePictureUrl: json['profilePictureUrl'],
          OAuthProvider: json['OAthProvider'],
          studentId: json['studentId'],
          department: json['department'],
      );
}
