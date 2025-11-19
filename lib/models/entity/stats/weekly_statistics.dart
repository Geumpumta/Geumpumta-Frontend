import 'package:geumpumta/models/dto/stats/weekly_statistics_response_dto.dart';

class WeeklyStatistics {
  final int totalWeekSeconds;
  final int averageDailySeconds;
  final int maxConsecutiveStudyDays;

  WeeklyStatistics({
    required this.totalWeekSeconds,
    required this.averageDailySeconds,
    required this.maxConsecutiveStudyDays,
  });

  factory WeeklyStatistics.fromDto(WeeklyStatisticsDto dto) {
    return WeeklyStatistics(
      totalWeekSeconds: dto.totalWeekSeconds,
      averageDailySeconds: dto.averageDailySeconds,
      maxConsecutiveStudyDays: dto.maxConsecutiveStudyDays,
    );
  }
}


