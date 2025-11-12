class CompleteRegistrationRequestDto {
  final String email;
  final String studentId;
  final String department;

  CompleteRegistrationRequestDto({
    required this.email,
    required this.studentId,
    required this.department,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'studentId': studentId,
    'department': department,
  };
}
