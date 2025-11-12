class VerifyCodeRequestDto{
  final String email;
  final String code;

  VerifyCodeRequestDto({required this.email, required this.code});

  Map<String, dynamic> toJson() => {
    'email' :email,
    'code':code,
  };
}