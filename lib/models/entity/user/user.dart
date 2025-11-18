class User {
  final String? name;
  final String? nickName;
  final String? email;
  final String? schoolEmail;
  final String? userRole;
  final String? profileImage;
  final String? oAuthProvider;
  final String? studentId;
  final String? department;
  final int? totalMillis;

  User({
    required this.name,
    required this.nickName,
    required this.email,
    required this.schoolEmail,
    required this.userRole,
    required this.profileImage,
    required this.oAuthProvider,
    required this.studentId,
    required this.department,
    this.totalMillis = 0,
  });

  User copyWith({
    String? name,
    String? nickName,
    String? email,
    String? schoolEmail,
    String? userRole,
    String? profileImage,
    String? oAuthProvider,
    String? studentId,
    String? department,
    int? totalMillis,
  }) {
    return User(
      name: name ?? this.name,
      nickName: nickName ?? this.nickName,
      email: email ?? this.email,
      schoolEmail: schoolEmail ?? this.schoolEmail,
      userRole: userRole ?? this.userRole,
      profileImage: profileImage ?? this.profileImage,
      oAuthProvider: oAuthProvider ?? this.oAuthProvider,
      studentId: studentId ?? this.studentId,
      department: department ?? this.department,
      totalMillis: totalMillis ?? this.totalMillis,
    );
  }
}
