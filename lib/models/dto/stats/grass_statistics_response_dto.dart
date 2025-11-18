class GrassStatisticsResponseDto {
  final bool success;
  final GrassStatisticsDataDto data;

  GrassStatisticsResponseDto({
    required this.success,
    required this.data,
  });

  factory GrassStatisticsResponseDto.fromJson(Map<String, dynamic> json) {
    return GrassStatisticsResponseDto(
      success: json['success'] == true || json['success'] == 'true',
      data: GrassStatisticsDataDto.fromJson(
        (json['data'] ?? const <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }
}

class GrassStatisticsDataDto {
  final List<GrassStatisticItemDto> grassStatistics;

  GrassStatisticsDataDto({required this.grassStatistics});

  factory GrassStatisticsDataDto.fromJson(Map<String, dynamic> json) {
    final list = (json['grassStatistics'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    return GrassStatisticsDataDto(
      grassStatistics:
          list.map((item) => GrassStatisticItemDto.fromJson(item)).toList(),
    );
  }
}

class GrassStatisticItemDto {
  final String date;
  final int level;

  GrassStatisticItemDto({
    required this.date,
    required this.level,
  });

  factory GrassStatisticItemDto.fromJson(Map<String, dynamic> json) {
    return GrassStatisticItemDto(
      date: json['date'] as String? ?? '',
      level: (json['level'] as num?)?.toInt() ?? 0,
    );
  }
}


