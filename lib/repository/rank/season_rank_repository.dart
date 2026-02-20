import 'package:geumpumta/models/dto/rank/get_season_ranking_response_dto.dart';
import 'package:geumpumta/service/retrofit/season_rank_api.dart';

class SeasonRankRepository {
  final SeasonRankApi seasonRankApi;

  SeasonRankRepository({required this.seasonRankApi});

  Future<GetSeasonRankingResponseDto> getCurrentSeasonRanking() async {
    try {
      final response = await seasonRankApi.getCurrentSeasonRanking();
      if (!response.success) {
        throw Exception('현재 시즌 랭킹 조회 실패 : ${response.message}');
      }
      return response;
    } catch (e, st) {
      print('[SeasonRankRepository] 오류 발생: $e\n$st');
      rethrow;
    }
  }

  Future<GetSeasonRankingResponseDto> getClosedSeasonRanking(int seasonId) async {
    try {
      final response = await seasonRankApi.getClosedSeasonRanking(seasonId);
      if (!response.success) {
        throw Exception('종료 시즌 랭킹 조회 실패 : ${response.message}');
      }
      return response;
    } catch (e, st) {
      print('[SeasonRankRepository] 오류 발생: $e\n$st');
      rethrow;
    }
  }
}
