import 'package:geumpumta/models/dto/stats/weekly_statistics_response_dto.dart';

class WeeklyStatistics {
  final int totalWeekMilliseconds;
  final int averageDailyMilliseconds;
  final int maxConsecutiveStudyDays;

  WeeklyStatistics({
    required this.totalWeekMilliseconds,
    required this.averageDailyMilliseconds,
    required this.maxConsecutiveStudyDays,
  });

  factory WeeklyStatistics.fromDto(WeeklyStatisticsDto dto) {
    return WeeklyStatistics(
      totalWeekMilliseconds: dto.totalWeekMilliseconds,
      averageDailyMilliseconds: dto.averageDailyMilliseconds,
      maxConsecutiveStudyDays: dto.maxConsecutiveStudyDays,
    );
  }
}

