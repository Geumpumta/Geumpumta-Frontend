import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/stats/grass_statistics.dart';
import 'package:geumpumta/provider/repository_provider.dart';
import 'package:geumpumta/repository/stats/grass_statistics_repository.dart';

final grassStatsViewModelProvider =
    StateNotifierProvider<GrassStatsViewModel, AsyncValue<GrassStatistics>>(
        (ref) {
  final repo = ref.watch(grassStatisticsRepositoryProvider);
  return GrassStatsViewModel(repo);
});

class GrassStatsViewModel extends StateNotifier<AsyncValue<GrassStatistics>> {
  GrassStatsViewModel(this._repository) : super(const AsyncLoading());

  final GrassStatisticsRepository _repository;

  Future<void> loadGrassStatistics({
    required String date,
    int? targetUserId,
  }) async {
    state = const AsyncLoading();
    try {
      final stats = await _repository.fetchGrassStatistics(
        date: date,
        targetUserId: targetUserId,
      );
      state = AsyncData(stats);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final grassStatisticsProvider =
    FutureProvider.family<GrassStatistics, DateTime>((ref, month) async {
  final repo = ref.watch(grassStatisticsRepositoryProvider);
  final formattedMonth = _formatMonth(month);
  return repo.fetchGrassStatistics(date: formattedMonth);
});

final currentStreakProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(grassStatisticsRepositoryProvider);
  final today = DateTime.now();
  final currentMonth = DateTime(today.year, today.month, 1);
  final previousMonth = DateTime(
    today.month == 1 ? today.year - 1 : today.year,
    today.month == 1 ? 12 : today.month - 1,
    1,
  );

  final entries = <GrassEntry>[];
  final current =
      await repo.fetchGrassStatistics(date: _formatMonth(currentMonth));
  entries.addAll(current.entries);
  final prev =
      await repo.fetchGrassStatistics(date: _formatMonth(previousMonth));
  entries.addAll(prev.entries);

  final byDate = <String, int>{
    for (final entry in entries) _formatDate(entry.date): entry.level,
  };

  int streak = 0;
  DateTime cursor = DateTime(today.year, today.month, today.day);
  bool skippedTodayOnce = false;

  while (true) {
    final level = byDate[_formatDate(cursor)] ?? 0;

    if (level <= 0) {
      if (!skippedTodayOnce && _isSameDay(cursor, today)) {
        skippedTodayOnce = true;
        cursor = cursor.subtract(const Duration(days: 1));
        continue;
      }
      break;
    }

    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
    final earliestSupported =
        DateTime(previousMonth.year, previousMonth.month, 1);
    if (cursor.isBefore(earliestSupported) &&
        !byDate.containsKey(_formatDate(cursor))) {
      break;
    }
  }

  return streak;
});

String _formatMonth(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  return '${date.year}-$month-01';
}

String _formatDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}


