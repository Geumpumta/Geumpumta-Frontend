import 'package:dio/dio.dart';
import 'package:geumpumta/models/dto/stats/weekly_statistics_response_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'weekly_statistics_api.g.dart';

@RestApi()
abstract class WeeklyStatisticsApi {
  factory WeeklyStatisticsApi(Dio dio, {String baseUrl}) = _WeeklyStatisticsApi;

  @GET('/api/v1/statistics/week')
  Future<WeeklyStatisticsResponseDto> getWeeklyStatistics({
    @Query('date') required String date,
    @Query('targetUserId') int? targetUserId,
  });
}

