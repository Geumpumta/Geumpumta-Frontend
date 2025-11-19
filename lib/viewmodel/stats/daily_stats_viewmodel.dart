import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/stats/daily_statistics.dart';
import 'package:geumpumta/provider/repository_provider.dart';
import 'package:geumpumta/repository/stats/daily_statistics_repository.dart';

final dailyStatsViewModelProvider =
    StateNotifierProvider<DailyStatsViewModel, AsyncValue<DailyStatistics>>(
        (ref) {
  final repo = ref.watch(dailyStatisticsRepositoryProvider);
  return DailyStatsViewModel(repo);
});

class DailyStatsViewModel extends StateNotifier<AsyncValue<DailyStatistics>> {
  DailyStatsViewModel(this._repository) : super(const AsyncLoading());

  final DailyStatisticsRepository _repository;

  Future<void> loadDailyStatistics({
    required String date,
    int? targetUserId,
  }) async {
    state = const AsyncLoading();
    try {
      final stats = await _repository.fetchDailyStatistics(
        date: date,
        targetUserId: targetUserId,
      );
      state = AsyncData(stats);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}


