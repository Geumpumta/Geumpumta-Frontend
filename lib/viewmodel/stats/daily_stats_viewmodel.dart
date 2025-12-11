import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/stats/daily_statistics.dart';
import 'package:geumpumta/provider/repository_provider.dart';
import 'package:geumpumta/repository/stats/daily_statistics_repository.dart';

final dailyStatsViewModelProvider = StateNotifierProvider.family
    .autoDispose<DailyStatsViewModel, AsyncValue<DailyStatistics>, int?>((
      ref,
      targetUserId,
    ) {
      final repo = ref.watch(dailyStatisticsRepositoryProvider);
      return DailyStatsViewModel(repo, targetUserId);
    });

class DailyStatsViewModel extends StateNotifier<AsyncValue<DailyStatistics>> {
  final DailyStatisticsRepository repo;
  final int? targetUserId;

  DailyStatsViewModel(this.repo, this.targetUserId)
    : super(const AsyncLoading());

  Future<void> loadDailyStatistics({required String date}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => repo.fetchDailyStatistics(date: date, targetUserId: targetUserId),
    );
  }
}
