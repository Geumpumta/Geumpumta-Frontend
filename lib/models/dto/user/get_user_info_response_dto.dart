import 'package:geumpumta/models/dto/user/user_data_dto.dart';

class GetUserInfoResponseDto {
  final bool success;
  final UserDataDto data;

  GetUserInfoResponseDto({required this.success, required this.data});

  factory GetUserInfoResponseDto.fromJson(Map<String, dynamic> json) =>
      GetUserInfoResponseDto(
        success: json['success'] == 'true' || json['success'] == true,
        data: UserDataDto.fromJson(json['data']),
      );
}
