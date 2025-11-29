import 'package:geumpumta/models/dto/stats/monthly_statistics_response_dto.dart';

class MonthlyStatistics {
  final int totalMonthSeconds;
  final int averageDailySeconds;
  final int studiedDays;
  final int maxConsecutiveStudyDays;

  MonthlyStatistics({
    required this.totalMonthSeconds,
    required this.averageDailySeconds,
    required this.studiedDays,
    required this.maxConsecutiveStudyDays,
  });

  factory MonthlyStatistics.fromDto(MonthlyStatisticsDto dto) {
    return MonthlyStatistics(
      totalMonthSeconds: dto.totalMonthSeconds,
      averageDailySeconds: dto.averageDailySeconds,
      studiedDays: dto.studiedDays,
      maxConsecutiveStudyDays: dto.maxConsecutiveStudyDays,
    );
  }
}


