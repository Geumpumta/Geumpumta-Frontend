class NicknameVerifyResponseDto {
  final bool success;
  final NicknameVerifyDataDto data;

  NicknameVerifyResponseDto({required this.success, required this.data});

  factory NicknameVerifyResponseDto.fromJson(Map<String, dynamic> json) {
    return NicknameVerifyResponseDto(
      success: json['success'] == true || json['success'] == 'true',
      data: NicknameVerifyDataDto.fromJson(
        (json['data'] ?? const <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }
}

class NicknameVerifyDataDto {
  final bool isAvailable;

  NicknameVerifyDataDto({required this.isAvailable});

  factory NicknameVerifyDataDto.fromJson(Map<String, dynamic> json) {
    return NicknameVerifyDataDto(
      isAvailable: json['isAvailable'] as bool? ?? false,
    );
  }
}


