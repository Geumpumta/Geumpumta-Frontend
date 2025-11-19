import 'package:geumpumta/models/entity/stats/daily_statistics.dart';
import 'package:geumpumta/service/retrofit/daily_statistics_api.dart';

class DailyStatisticsRepository {
  DailyStatisticsRepository(this._api);

  final DailyStatisticsApi _api;

  Future<DailyStatistics> fetchDailyStatistics({
    required String date,
    int? targetUserId,
  }) async {
    final response = await _api.getDailyStatistics(
      date: date,
      targetUserId: targetUserId,
    );
    return DailyStatistics.fromDto(response.data);
  }
}

