import 'package:geumpumta/models/department.dart';

class User {
  final String? name;
  final String? nickName;
  final String? email;
  final String? schoolEmail;
  final String? userRole;
  final String? profileImage;
  final String? oAuthProvider;
  final String? studentId;
  final Department department;
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

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'],
    nickName: json['nickName'],
    email: json['email'],
    schoolEmail: json['schoolEmail'],
    userRole: json['userRole'],
    profileImage: json['profileImage'],
    oAuthProvider: json['oAuthProvider'],
    studentId: json['studentId'],
    department: DepartmentParser.fromKorean(json['department']),
    totalMillis: json['totalMillis'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'nickName': nickName,
    'email': email,
    'schoolEmail': schoolEmail,
    'userRole': userRole,
    'profileImage': profileImage,
    'oAuthProvider': oAuthProvider,
    'studentId': studentId,
    'department': department.koreanName,
    'totalMillis': totalMillis,
  };

  User copyWith({
    String? name,
    String? nickName,
    String? email,
    String? schoolEmail,
    String? userRole,
    String? profileImage,
    String? oAuthProvider,
    String? studentId,
    Department? department,
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
