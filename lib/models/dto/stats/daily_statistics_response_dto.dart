class DailyStatisticsResponseDto {
  final bool success;
  final DailyStatisticsDataDto data;

  DailyStatisticsResponseDto({
    required this.success,
    required this.data,
  });

  factory DailyStatisticsResponseDto.fromJson(Map<String, dynamic> json) {
    return DailyStatisticsResponseDto(
      success: json['success'] == true || json['success'] == 'true',
      data: DailyStatisticsDataDto.fromJson(
        (json['data'] ?? const <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }
}

class DailyStatisticsDataDto {
  final List<DailySlotDto> statisticsList;
  final DaySummaryDto dayMaxFocusAndFullTimeStatistics;

  DailyStatisticsDataDto({
    required this.statisticsList,
    required this.dayMaxFocusAndFullTimeStatistics,
  });

  factory DailyStatisticsDataDto.fromJson(Map<String, dynamic> json) {
    final list = (json['statisticsList'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    return DailyStatisticsDataDto(
      statisticsList: list.map((item) => DailySlotDto.fromJson(item)).toList(),
      dayMaxFocusAndFullTimeStatistics:
          DaySummaryDto.fromJson(json['dayMaxFocusAndFullTimeStatistics']
                  as Map<String, dynamic>? ??
              const <String, dynamic>{}),
    );
  }
}

class DailySlotDto {
  final String slotStart;
  final String slotEnd;
  final int millisecondsStudied;

  DailySlotDto({
    required this.slotStart,
    required this.slotEnd,
    required this.millisecondsStudied,
  });

  factory DailySlotDto.fromJson(Map<String, dynamic> json) {
    return DailySlotDto(
      slotStart: json['slotStart'] as String? ?? '',
      slotEnd: json['slotEnd'] as String? ?? '',
      millisecondsStudied: (json['millisecondsStudied'] as num?)?.toInt() ?? 0,
    );
  }
}

class DaySummaryDto {
  final int totalStudyMilliseconds;
  final int maxFocusMilliseconds;

  DaySummaryDto({
    required this.totalStudyMilliseconds,
    required this.maxFocusMilliseconds,
  });

  factory DaySummaryDto.fromJson(Map<String, dynamic> json) {
    return DaySummaryDto(
      totalStudyMilliseconds: (json['totalStudyMilliseconds'] as num?)?.toInt() ?? 0,
      maxFocusMilliseconds: (json['maxFocusMilliseconds'] as num?)?.toInt() ?? 0,
    );
  }
}


