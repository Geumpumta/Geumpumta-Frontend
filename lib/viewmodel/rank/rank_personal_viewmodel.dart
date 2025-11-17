import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/dto/rank/get_personal_ranking_response_dto.dart';
import 'package:geumpumta/provider/repository_provider.dart';
import 'package:geumpumta/repository/rank/rank_repository.dart';

final rankPersonalViewModelProvider =
    StateNotifierProvider<
      RankPersonalViewmodel,
      AsyncValue<GetPersonalRankingResponseDto?>
    >((ref) {
      final repository = ref.watch(rankRepositoryProvider);
      return RankPersonalViewmodel(ref, repository);
    });

class RankPersonalViewmodel
    extends StateNotifier<AsyncValue<GetPersonalRankingResponseDto?>> {
  final Ref ref;
  final RankRepository repository;

  RankPersonalViewmodel(this.ref, this.repository):super(const AsyncData(null));

  Future<void> getWeeklyPersonalRanking(DateTime date) async{
    state = AsyncLoading();
    try{
      final response = await repository.getWeeklyPersonalRanking(date);
      state = AsyncData(response);
    }catch(e,st){
      print('[RankPersonalmentViewmodel] 오류 발생: $e\n$st');
      state = AsyncError(e, st);
    }
  }

  Future<void> getDailyPersonalRanking(DateTime date) async{
    state = AsyncLoading();
    try{
      final response = await repository.getDailyPersonalRanking(date);
      state = AsyncData(response);
    }catch(e,st){
      print('[RankPersonalmentViewmodel] 오류 발생: $e\n$st');
      state = AsyncError(e, st);
    }
  }

  Future<void> getMonthlyPersonalRanking(DateTime date) async{
    state = AsyncLoading();
    try{
      final response = await repository.getMonthlyPersonalRanking(date);
      state = AsyncData(response);
    }catch(e,st){
      print('[RankPersonalmentViewmodel] 오류 발생: $e\n$st');
      state = AsyncError(e, st);
    }
  }

}
