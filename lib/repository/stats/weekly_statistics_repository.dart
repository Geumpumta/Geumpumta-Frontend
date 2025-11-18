import 'package:geumpumta/models/entity/stats/weekly_statistics.dart';
import 'package:geumpumta/service/retrofit/weekly_statistics_api.dart';

class WeeklyStatisticsRepository {
  WeeklyStatisticsRepository(this._api);

  final WeeklyStatisticsApi _api;

  Future<WeeklyStatistics> fetchWeeklyStatistics({
    required String date,
    int? targetUserId,
  }) async {
    final response = await _api.getWeeklyStatistics(
      date: date,
      targetUserId: targetUserId,
    );
    return WeeklyStatistics.fromDto(response.data.weeklyStatistics);
  }
}

