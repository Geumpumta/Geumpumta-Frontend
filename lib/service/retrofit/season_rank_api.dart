import 'package:dio/dio.dart';
import 'package:geumpumta/models/dto/rank/get_season_ranking_response_dto.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'season_rank_api.g.dart';

@RestApi()
abstract class SeasonRankApi {
  factory SeasonRankApi(Dio dio, {String baseUrl}) = _SeasonRankApi;

  @GET('/api/v1/rank/season/current')
  Future<GetSeasonRankingResponseDto> getCurrentSeasonRanking();

  @GET('/api/v1/rank/season/{seasonId}')
  Future<GetSeasonRankingResponseDto> getClosedSeasonRanking(
    @Path('seasonId') int seasonId,
  );
}
