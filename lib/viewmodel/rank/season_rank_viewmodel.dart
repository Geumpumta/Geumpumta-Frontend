import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/dto/rank/get_season_ranking_response_dto.dart';
import 'package:geumpumta/provider/repository_provider.dart';
import 'package:geumpumta/repository/rank/season_rank_repository.dart';

final seasonRankViewModelProvider = StateNotifierProvider<
    SeasonRankViewmodel, AsyncValue<GetSeasonRankingResponseDto?>>((ref) {
  final repository = ref.watch(seasonRankRepositoryProvider);
  return SeasonRankViewmodel(ref, repository);
});

class SeasonRankViewmodel
    extends StateNotifier<AsyncValue<GetSeasonRankingResponseDto?>> {
  final Ref ref;
  final SeasonRankRepository repository;

  SeasonRankViewmodel(this.ref, this.repository) : super(const AsyncData(null));

  Future<void> getCurrentSeasonRanking() async {
    state = const AsyncLoading();
    try {
      final response = await repository.getCurrentSeasonRanking();
      state = AsyncData(response);
    } catch (e, st) {
      print('[SeasonRankViewmodel] 오류 발생: $e\n$st');
      state = AsyncError(e, st);
    }
  }

  Future<void> getClosedSeasonRanking(int seasonId) async {
    state = const AsyncLoading();
    try {
      final response = await repository.getClosedSeasonRanking(seasonId);
      state = AsyncData(response);
    } catch (e, st) {
      print('[SeasonRankViewmodel] 오류 발생: $e\n$st');
      state = AsyncError(e, st);
    }
  }
}
