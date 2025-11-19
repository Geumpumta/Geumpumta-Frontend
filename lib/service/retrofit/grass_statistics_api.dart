import 'package:dio/dio.dart';
import 'package:geumpumta/models/dto/stats/grass_statistics_response_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'grass_statistics_api.g.dart';

@RestApi()
abstract class GrassStatisticsApi {
  factory GrassStatisticsApi(Dio dio, {String baseUrl}) = _GrassStatisticsApi;

  @GET('/api/v1/statistics/grass')
  Future<GrassStatisticsResponseDto> getGrassStatistics({
    @Query('date') required String date,
    @Query('targetUserId') int? targetUserId,
  });
}

