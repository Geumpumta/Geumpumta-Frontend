class SendEmailVerificationRequestDto{
  final String email;

  SendEmailVerificationRequestDto({required this.email});

  Map<String, dynamic> toJson() => {
    'email' :email,
  };
}