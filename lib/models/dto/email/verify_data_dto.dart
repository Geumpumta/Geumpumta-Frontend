class VerifyDataDto {
  final bool isVerified;

  VerifyDataDto({required this.isVerified});

  factory VerifyDataDto.fromJson(Map<String, dynamic> json) =>
      VerifyDataDto(isVerified: json['isVerified']);
}
