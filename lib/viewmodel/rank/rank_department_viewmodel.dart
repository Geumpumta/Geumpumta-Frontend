import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/provider/repository_provider.dart';
import 'package:geumpumta/repository/rank/rank_repository.dart';
import '../../models/dto/rank/get_department_ranking_response_dto.dart';

final rankDepartmentViewModelProvider =
StateNotifierProvider<
    RankDepartmentViewmodel,
    AsyncValue<GetDepartmentRankingResponseDto?>
>((ref) {
  final repository = ref.watch(rankRepositoryProvider);
  return RankDepartmentViewmodel(ref, repository);
});

class RankDepartmentViewmodel
    extends StateNotifier<AsyncValue<GetDepartmentRankingResponseDto?>> {
  final Ref ref;
  final RankRepository repository;

  RankDepartmentViewmodel(this.ref, this.repository):super(const AsyncData(null));

  Future<void> getWeeklyDepartmentRanking(DateTime? date) async{
    state = AsyncLoading();
    try{
      final response = await repository.getWeeklyDepartmentRanking(date);
      state = AsyncData(response);
    }catch(e,st){
      print('[RankDepartmentViewmodel] 오류 발생: $e\n$st');
      state = AsyncError(e, st);
    }
  }

  Future<void> getDailyDepartmentRanking(DateTime? date) async{
    state = AsyncLoading();
    try{
      final response = await repository.getDailyDepartmentRanking(date);
      state = AsyncData(response);
    }catch(e,st){
      print('[RankDepartmentViewmodel] 오류 발생: $e\n$st');
      state = AsyncError(e, st);
    }
  }

  Future<void> getMonthlyDepartmentRanking(DateTime? date) async{
    state = AsyncLoading();
    try{
      final response = await repository.getMonthlyDepartmentRanking(date);
      state = AsyncData(response);
    }catch(e,st){
      print('[RankDepartmentViewmodel] 오류 발생: $e\n$st');
      state = AsyncError(e, st);
    }
  }
}
