import 'board_list_item_dto.dart';

class BoardListResponseDto {
  final bool success;
  final List<BoardListItemDto> data;

  BoardListResponseDto({
    required this.success,
    required this.data,
  });

  factory BoardListResponseDto.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List<dynamic>? ?? [])
        .map((item) => BoardListItemDto.fromJson(
            item as Map<String, dynamic>))
        .toList();

    return BoardListResponseDto(
      success: json['success'] == true || json['success'] == 'true',
      data: dataList,
    );
  }
}

