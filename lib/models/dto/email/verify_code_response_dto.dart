import 'package:geumpumta/models/dto/email/verify_data_dto.dart';

class VerifyCodeResponseDto {
  final bool success;
  final VerifyDataDto data;

  VerifyCodeResponseDto({required this.success, required this.data});

  factory VerifyCodeResponseDto.fromJson(Map<String, dynamic> json) =>
      VerifyCodeResponseDto(success: json['success'], data: json['data']);
}
