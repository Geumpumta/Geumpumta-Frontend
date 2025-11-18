import 'package:geumpumta/models/entity/stats/monthly_statistics.dart';
import 'package:geumpumta/service/retrofit/monthly_statistics_api.dart';

class MonthlyStatisticsRepository {
  MonthlyStatisticsRepository(this._api);

  final MonthlyStatisticsApi _api;

  Future<MonthlyStatistics> fetchMonthlyStatistics({
    required String date,
    int? targetUserId,
  }) async {
    final response = await _api.getMonthlyStatistics(
      date: date,
      targetUserId: targetUserId,
    );
    return MonthlyStatistics.fromDto(response.data.monthlyStatistics);
  }
}

