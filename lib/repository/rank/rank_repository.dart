import 'package:geumpumta/models/dto/rank/get_department_ranking_response_dto.dart';
import 'package:geumpumta/models/dto/rank/get_personal_ranking_response_dto.dart';
import 'package:geumpumta/service/retrofit/rank_api.dart';

class RankRepository {
  final RankApi rankApi;

  RankRepository({required this.rankApi});

  Future<GetDepartmentRankingResponseDto> getWeeklyDepartmentRanking(DateTime? date)async{
    try {
      final response = await rankApi.getWeeklyDepartmentRanking(date?.toIso8601String());
      if (!response.success) throw Exception('주간 학과별 랭킹 정보 조회 실패 : ${response.message}');
      return response;
    } catch (e,st) {
      print('[RankRepository] 오류 발생: $e\n$st');
      rethrow;
    }
  }

  Future<GetDepartmentRankingResponseDto> getMonthlyDepartmentRanking(DateTime? date)async{
    try {
      final response = await rankApi.getMonthlyDepartmentRanking(date?.toIso8601String());
      if (!response.success) throw Exception('월간 학과별 랭킹 정보 조회 실패 : ${response.message}');
      return response;
    } catch (e,st) {
      print('[RankRepository] 오류 발생: $e\n$st');
      rethrow;
    }
  }

  Future<GetDepartmentRankingResponseDto> getDailyDepartmentRanking(DateTime? date)async{
    try {
      final response = await rankApi.getDailyDepartmentRanking(date?.toIso8601String());
      if (!response.success) throw Exception('일간 학과별 랭킹 정보 조회 실패 : ${response.message}');
      return response;
    } catch (e,st) {
      print('[RankRepository] 오류 발생: $e\n$st');
      rethrow;
    }
  }

  Future<GetPersonalRankingResponseDto> getWeeklyPersonalRanking(DateTime? date)async{
    try {
      final response = await rankApi.getWeeklyPersonalRanking(date?.toIso8601String());
      if (!response.success) throw Exception('주간 개인별 랭킹 정보 조회 실패 : ${response.message}');
      return response;
    } catch (e,st) {
      print('[RankRepository] 오류 발생: $e\n$st');
      rethrow;
    }
  }

  Future<GetPersonalRankingResponseDto> getMonthlyPersonalRanking(DateTime? date)async{
    try {
      final response = await rankApi.getMonthlyPersonalRanking(date?.toIso8601String());
      if (!response.success) throw Exception('월간 개인별 랭킹 정보 조회 실패 : ${response.message}');
      return response;
    } catch (e,st) {
      print('[RankRepository] 오류 발생: $e\n$st');
      rethrow;
    }
  }

  Future<GetPersonalRankingResponseDto> getDailyPersonalRanking(DateTime? date)async{
    try {
      final response = await rankApi.getDailyPersonalRanking(date?.toIso8601String());
      if (!response.success) throw Exception('일간 개인별 랭킹 정보 조회 실패 : ${response.message}');
      return response;
    } catch (e,st) {
      print('[RankRepository] 오류 발생: $e\n$st');
      rethrow;
    }
  }

}