import 'package:dio/dio.dart';
import 'package:geumpumta/models/dto/stats/monthly_statistics_response_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'monthly_statistics_api.g.dart';

@RestApi()
abstract class MonthlyStatisticsApi {
  factory MonthlyStatisticsApi(Dio dio, {String baseUrl}) =
      _MonthlyStatisticsApi;

  @GET('/api/v1/statistics/month')
  Future<MonthlyStatisticsResponseDto> getMonthlyStatistics({
    @Query('date') required String date,
    @Query('targetUserId') int? targetUserId,
  });
}

