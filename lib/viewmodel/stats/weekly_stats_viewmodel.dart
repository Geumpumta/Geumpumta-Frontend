import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/stats/weekly_statistics.dart';
import 'package:geumpumta/provider/repository_provider.dart';
import 'package:geumpumta/repository/stats/weekly_statistics_repository.dart';

final weeklyStatsViewModelProvider =
    StateNotifierProvider<WeeklyStatsViewModel, AsyncValue<WeeklyStatistics>>(
        (ref) {
  final repo = ref.watch(weeklyStatisticsRepositoryProvider);
  return WeeklyStatsViewModel(repo);
});

class WeeklyStatsViewModel extends StateNotifier<AsyncValue<WeeklyStatistics>> {
  WeeklyStatsViewModel(this._repository) : super(const AsyncLoading());

  final WeeklyStatisticsRepository _repository;

  Future<void> loadWeeklyStatistics({
    required String date,
    int? targetUserId,
  }) async {
    state = const AsyncLoading();
    try {
      final stats = await _repository.fetchWeeklyStatistics(
        date: date,
        targetUserId: targetUserId,
      );
      state = AsyncData(stats);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}


