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
    // date 문자열을 DateTime으로 파싱 (예: "2025-12-04")
    final dateTime = DateTime.parse(date);
    return DailyStatistics.fromDto(response.data, dateTime);
  }
}

