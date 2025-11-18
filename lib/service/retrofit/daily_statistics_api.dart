import 'package:dio/dio.dart';
import 'package:geumpumta/models/dto/stats/daily_statistics_response_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'daily_statistics_api.g.dart';

@RestApi()
abstract class DailyStatisticsApi {
  factory DailyStatisticsApi(Dio dio, {String baseUrl}) = _DailyStatisticsApi;

  @GET('/api/v1/statistics/day')
  Future<DailyStatisticsResponseDto> getDailyStatistics({
    @Query('date') required String date,
    @Query('targetUserId') int? targetUserId,
  });
}

