class MonthlyStatisticsResponseDto {
  final bool success;
  final MonthlyStatisticsDataDto data;

  MonthlyStatisticsResponseDto({
    required this.success,
    required this.data,
  });

  factory MonthlyStatisticsResponseDto.fromJson(Map<String, dynamic> json) {
    return MonthlyStatisticsResponseDto(
      success: json['success'] == true || json['success'] == 'true',
      data: MonthlyStatisticsDataDto.fromJson(
        (json['data'] ?? const <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }
}

class MonthlyStatisticsDataDto {
  final MonthlyStatisticsDto monthlyStatistics;

  MonthlyStatisticsDataDto({required this.monthlyStatistics});

  factory MonthlyStatisticsDataDto.fromJson(Map<String, dynamic> json) {
    return MonthlyStatisticsDataDto(
      monthlyStatistics: MonthlyStatisticsDto.fromJson(
        (json['monthlyStatistics'] ?? const <String, dynamic>{})
            as Map<String, dynamic>,
      ),
    );
  }
}

class MonthlyStatisticsDto {
  final int totalMonthlySeconds;
  final int averageDailySeconds;
  final int studiedDays;
  final int maxConsecutiveStudyDays;

  MonthlyStatisticsDto({
    required this.totalMonthlySeconds,
    required this.averageDailySeconds,
    required this.studiedDays,
    required this.maxConsecutiveStudyDays,
  });

  factory MonthlyStatisticsDto.fromJson(Map<String, dynamic> json) {
    return MonthlyStatisticsDto(
      totalMonthlySeconds: (json['totalMonthlySeconds'] as num?)?.toInt() ?? 0,
      averageDailySeconds: (json['averageDailySeconds'] as num?)?.toInt() ?? 0,
      studiedDays: (json['studiedDays'] as num?)?.toInt() ?? 0,
      maxConsecutiveStudyDays:
          (json['maxConsecutiveStudyDays'] as num?)?.toInt() ?? 0,
    );
  }
}


