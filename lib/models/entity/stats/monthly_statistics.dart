import 'package:geumpumta/models/dto/stats/monthly_statistics_response_dto.dart';

class MonthlyStatistics {
  final int totalMonthMilliseconds;
  final int averageDailyMilliseconds;
  final int studiedDays;
  final int maxConsecutiveStudyDays;

  MonthlyStatistics({
    required this.totalMonthMilliseconds,
    required this.averageDailyMilliseconds,
    required this.studiedDays,
    required this.maxConsecutiveStudyDays,
  });

  factory MonthlyStatistics.fromDto(MonthlyStatisticsDto dto) {
    return MonthlyStatistics(
      totalMonthMilliseconds: dto.totalMonthMilliseconds,
      averageDailyMilliseconds: dto.averageDailyMilliseconds,
      studiedDays: dto.studiedDays,
      maxConsecutiveStudyDays: dto.maxConsecutiveStudyDays,
    );
  }
}

