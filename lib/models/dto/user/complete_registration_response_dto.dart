class RegistrationTokenDto {
  final String accessToken;
  final String refreshToken;

  RegistrationTokenDto({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RegistrationTokenDto.fromJson(Map<String, dynamic> json) =>
      RegistrationTokenDto(
        accessToken: (json['accessToken'] ?? '') as String,
        refreshToken: (json['refreshToken'] ?? '') as String,
      );
}

class CompleteResitrationDataDto {
  final RegistrationTokenDto? token;

  CompleteResitrationDataDto({
    required this.token,
  });

  factory CompleteResitrationDataDto.fromJson(Map<String, dynamic> json) =>
      CompleteResitrationDataDto(
        token: json['token'] == null
            ? null
            : RegistrationTokenDto.fromJson(
                json['token'] as Map<String, dynamic>,
              ),
      );
}

class CompleteRegistrationResponseDto {
  final bool success;
  final CompleteResitrationDataDto? data;
  final String? code;
  final String? msg;

  CompleteRegistrationResponseDto({
    required this.success,
    this.data,
    this.msg,
    this.code,
  });

  factory CompleteRegistrationResponseDto.fromJson(Map<String, dynamic> json) =>
      CompleteRegistrationResponseDto(
        success: json['success'] == 'true' || json['success'] == true,
        data: json['data'] != null
            ? CompleteResitrationDataDto.fromJson(
                json['data'] as Map<String, dynamic>,
              )
            : null,
        code: json['code'],
        msg: json['message'] ?? json['msg'],
      );
}
