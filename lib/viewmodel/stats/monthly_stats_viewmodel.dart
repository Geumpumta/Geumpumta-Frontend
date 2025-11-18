import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/stats/monthly_statistics.dart';
import 'package:geumpumta/provider/repository_provider.dart';
import 'package:geumpumta/repository/stats/monthly_statistics_repository.dart';

final monthlyStatsViewModelProvider =
    StateNotifierProvider<MonthlyStatsViewModel, AsyncValue<MonthlyStatistics>>(
        (ref) {
  final repo = ref.watch(monthlyStatisticsRepositoryProvider);
  return MonthlyStatsViewModel(repo);
});

class MonthlyStatsViewModel
    extends StateNotifier<AsyncValue<MonthlyStatistics>> {
  MonthlyStatsViewModel(this._repository) : super(const AsyncLoading());

  final MonthlyStatisticsRepository _repository;

  Future<void> loadMonthlyStatistics({
    required String date,
    int? targetUserId,
  }) async {
    state = const AsyncLoading();
    try {
      final stats = await _repository.fetchMonthlyStatistics(
        date: date,
        targetUserId: targetUserId,
      );
      state = AsyncData(stats);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}


