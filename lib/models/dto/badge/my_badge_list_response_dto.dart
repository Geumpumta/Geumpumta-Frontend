import 'package:geumpumta/models/dto/badge/badge_response_dto.dart';

class MyBadgeListResponseDto {
  MyBadgeListResponseDto({
    required this.success,
    required this.data,
  });

  final bool success;
  final List<BadgeDto> data;

  factory MyBadgeListResponseDto.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final List<dynamic> items;

    if (rawData is List) {
      items = rawData;
    } else if (rawData is Map<String, dynamic> && rawData['badges'] is List) {
      items = rawData['badges'] as List<dynamic>;
    } else if (rawData is Map<String, dynamic>) {
      items = <dynamic>[rawData];
    } else {
      items = const <dynamic>[];
    }

    return MyBadgeListResponseDto(
      success: json['success'] == true || json['success'] == 'true',
      data: items
          .whereType<Map<String, dynamic>>()
          .map(BadgeDto.fromJson)
          .toList(),
    );
  }
}
