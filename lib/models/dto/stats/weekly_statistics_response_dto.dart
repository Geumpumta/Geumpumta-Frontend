class WeeklyStatisticsResponseDto {
  final bool success;
  final WeeklyStatisticsDataDto data;

  WeeklyStatisticsResponseDto({
    required this.success,
    required this.data,
  });

  factory WeeklyStatisticsResponseDto.fromJson(Map<String, dynamic> json) {
    return WeeklyStatisticsResponseDto(
      success: json['success'] == true || json['success'] == 'true',
      data: WeeklyStatisticsDataDto.fromJson(
        (json['data'] ?? const <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }
}

class WeeklyStatisticsDataDto {
  final WeeklyStatisticsDto weeklyStatistics;

  WeeklyStatisticsDataDto({required this.weeklyStatistics});

  factory WeeklyStatisticsDataDto.fromJson(Map<String, dynamic> json) {
    return WeeklyStatisticsDataDto(
      weeklyStatistics: WeeklyStatisticsDto.fromJson(
        (json['weeklyStatistics'] ?? const <String, dynamic>{})
            as Map<String, dynamic>,
      ),
    );
  }
}

class WeeklyStatisticsDto {
  final int totalWeekSeconds;
  final int averageDailySeconds;
  final int maxConsecutiveStudyDays;

  WeeklyStatisticsDto({
    required this.totalWeekSeconds,
    required this.averageDailySeconds,
    required this.maxConsecutiveStudyDays,
  });

  factory WeeklyStatisticsDto.fromJson(Map<String, dynamic> json) {
    return WeeklyStatisticsDto(
      totalWeekSeconds: (json['totalWeekSeconds'] as num?)?.toInt() ?? 0,
      averageDailySeconds: (json['averageDailySeconds'] as num?)?.toInt() ?? 0,
      maxConsecutiveStudyDays:
          (json['maxConsecutiveStudyDays'] as num?)?.toInt() ?? 0,
    );
  }
}


