class CompleteResitrationDataDto {
  final String accessToken;
  final String refreshToken;

  CompleteResitrationDataDto({
    required this.accessToken,
    required this.refreshToken,
  });

  factory CompleteResitrationDataDto.fromJson(Map<String, dynamic> json) =>
      CompleteResitrationDataDto(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
      );
}

class CompleteRegistrationResponseDto {
  final bool success;
  final CompleteResitrationDataDto? data;
  final String? code;
  final String? msg;

  CompleteRegistrationResponseDto({required this.success, this.data, this.msg, this.code});

  factory CompleteRegistrationResponseDto.fromJson(Map<String, dynamic> json) =>
      CompleteRegistrationResponseDto(
        success: json['success']=='true'||json['success']==true,
        data: json['data'] != null 
            ? CompleteResitrationDataDto.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        code: json['code'],
        msg: json['message'] ?? json['msg'],
      );
}
