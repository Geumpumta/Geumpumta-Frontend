class SignInState {
  final String studentId;
  final String email;
  final String department;

  const SignInState({
    this.studentId = '',
    this.email = '',
    this.department = '',
  });

  SignInState copyWith({
    String? studentId,
    String? email,
    String? code,
    String? department,
  }) {
    return SignInState(
      studentId: studentId ?? this.studentId,
      email: email ?? this.email,
      department: department ?? this.department,
    );
  }

  bool get isStep1Filled => studentId.isNotEmpty && email.isNotEmpty;
  bool get isStep3Filled => department.isNotEmpty;
}
