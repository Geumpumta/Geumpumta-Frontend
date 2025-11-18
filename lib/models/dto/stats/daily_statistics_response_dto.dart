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
  final int secondsStudied;

  DailySlotDto({
    required this.slotStart,
    required this.slotEnd,
    required this.secondsStudied,
  });

  factory DailySlotDto.fromJson(Map<String, dynamic> json) {
    return DailySlotDto(
      slotStart: json['slotStart'] as String? ?? '',
      slotEnd: json['slotEnd'] as String? ?? '',
      secondsStudied: (json['secondsStudied'] as num?)?.toInt() ?? 0,
    );
  }
}

class DaySummaryDto {
  final int totalStudySeconds;
  final int maxFocusSeconds;

  DaySummaryDto({
    required this.totalStudySeconds,
    required this.maxFocusSeconds,
  });

  factory DaySummaryDto.fromJson(Map<String, dynamic> json) {
    return DaySummaryDto(
      totalStudySeconds: (json['totalStudySeconds'] as num?)?.toInt() ?? 0,
      maxFocusSeconds: (json['maxFocusSeconds'] as num?)?.toInt() ?? 0,
    );
  }
}


