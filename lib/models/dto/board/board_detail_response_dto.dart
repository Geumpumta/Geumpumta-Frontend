import 'board_detail_dto.dart';

class BoardDetailResponseDto {
  final bool success;
  final BoardDetailDto data;

  BoardDetailResponseDto({
    required this.success,
    required this.data,
  });

  factory BoardDetailResponseDto.fromJson(Map<String, dynamic> json) {
    return BoardDetailResponseDto(
      success: json['success'] == true || json['success'] == 'true',
      data: BoardDetailDto.fromJson(
        (json['data'] ?? const <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }
}

