import 'package:geumpumta/models/entity/stats/grass_statistics.dart';
import 'package:geumpumta/service/retrofit/grass_statistics_api.dart';

class GrassStatisticsRepository {
  GrassStatisticsRepository(this._api);

  final GrassStatisticsApi _api;

  Future<GrassStatistics> fetchGrassStatistics({
    required String date,
    int? targetUserId,
  }) async {
    final response = await _api.getGrassStatistics(
      date: date,
      targetUserId: targetUserId,
    );
    return GrassStatistics.fromDto(response.data);
  }
}

