import 'package:dio/dio.dart';
import 'package:geumpumta/models/dto/rank/get_department_ranking_response_dto.dart';
import 'package:geumpumta/models/dto/rank/get_personal_ranking_response_dto.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'rank_api.g.dart';

@RestApi()
abstract class RankApi {
  factory RankApi(Dio dio, {String baseUrl}) = _RankApi;

  @GET('/api/v1/rank/department/weekly')
  Future<GetDepartmentRankingResponseDto> getWeeklyDepartmentRanking(
    @Query('date') String date,
  );

  @GET('/api/v1/rank/department/monthly')
  Future<GetDepartmentRankingResponseDto> getMonthlyDepartmentRanking(
    @Query('date') String date,
  );

  @GET('/api/v1/rank/department/daily')
  Future<GetDepartmentRankingResponseDto> getDailyDepartmentRanking(
    @Query('date') String date,
  );

  @GET('/api/v1/rank/personal/weekly')
  Future<GetPersonalRankingResponseDto> getWeeklyPersonalRanking(
    @Query('date') String date,
  );

  @GET('/api/v1/rank/personal/monthly')
  Future<GetPersonalRankingResponseDto> getMonthlyPersonalRanking(
    @Query('date') String date,
  );

  @GET('/api/v1/rank/personal/daily')
  Future<GetPersonalRankingResponseDto> getDailyPersonalRanking(
    @Query('date') String date,
  );
}
