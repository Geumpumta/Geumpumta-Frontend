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
  final int totalMonthSeconds;
  final int averageDailySeconds;
  final int studiedDays;
  final int maxConsecutiveStudyDays;

  MonthlyStatisticsDto({
    required this.totalMonthSeconds,
    required this.averageDailySeconds,
    required this.studiedDays,
    required this.maxConsecutiveStudyDays,
  });

  factory MonthlyStatisticsDto.fromJson(Map<String, dynamic> json) {
    final totalSeconds = _parseInt(json, ['totalMonthSeconds', 'totalMonthlySeconds', 'total_monthly_seconds']);
    final avgSeconds = _parseInt(json, ['averageDailySeconds', 'average_daily_seconds']);
    final days = _parseInt(json, ['studiedDays', 'studied_days']);
    final maxDays = _parseInt(json, ['maxConsecutiveStudyDays', 'max_consecutive_study_days']);
    
    return MonthlyStatisticsDto(
      totalMonthSeconds: totalSeconds,
      averageDailySeconds: avgSeconds,
      studiedDays: days,
      maxConsecutiveStudyDays: maxDays,
    );
  }
  
  static int _parseInt(Map<String, dynamic> json, List<String> possibleKeys) {
    for (final key in possibleKeys) {
      final value = json[key];
      if (value != null) {
        if (value is num) {
          return value.toInt();
        } else if (value is String) {
          final parsed = int.tryParse(value);
          if (parsed != null) return parsed;
        }
      }
    }
    return 0;
  }
}


