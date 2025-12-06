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
    FutureProvider.family<GrassStatistics, (DateTime, int?)>((ref, params) async {
  final repo = ref.watch(grassStatisticsRepositoryProvider);
  final month = params.$1;
  final targetUserId = params.$2;
  final formattedMonth = _formatMonth(month);
  return repo.fetchGrassStatistics(
    date: formattedMonth,
    targetUserId: targetUserId,
  );
});

final monthlyStreakProvider =
FutureProvider.autoDispose.family<int, (int? userId, DateTime month)>((ref, params) async {

  final userId = params.$1;
  final selectedMonth = params.$2;

  final repo = ref.watch(grassStatisticsRepositoryProvider);

  final stats = await repo.fetchGrassStatistics(
    date: _formatMonth(selectedMonth),
    targetUserId: userId,
  );

  final entries = stats.entries;
  entries.sort((a, b) => a.date.compareTo(b.date));

  int streak = 0;
  int maxStreak = 0;

  for (final e in entries) {
    if (e.level > 0) {
      streak++;
      maxStreak = (streak > maxStreak) ? streak : maxStreak;
    } else {
      streak = 0;
    }
  }

  return maxStreak;
});


final currentStreakProvider = FutureProvider.autoDispose.family<int, int?>((ref, targetUserId) async {
  final repo = ref.watch(grassStatisticsRepositoryProvider);
  final today = DateTime.now();
  final currentMonth = DateTime(today.year, today.month, 1);
  final previousMonth = DateTime(
    today.month == 1 ? today.year - 1 : today.year,
    today.month == 1 ? 12 : today.month - 1,
    1,
  );

  final entries = <GrassEntry>[];
  final current = await repo.fetchGrassStatistics(
    date: _formatMonth(currentMonth),
    targetUserId: targetUserId,
  );
  entries.addAll(current.entries);
  final prev = await repo.fetchGrassStatistics(
    date: _formatMonth(previousMonth),
    targetUserId: targetUserId,
  );
  entries.addAll(prev.entries);

  final byDate = <String, int>{
    for (final entry in entries) _formatDate(entry.date): entry.level,
  };

  // 오늘 날짜
  final todayDate = DateTime(today.year, today.month, today.day);
  final todayLevel = byDate[_formatDate(todayDate)] ?? 0;

  // 오늘이 level 0이면 0일차
  if (todayLevel <= 0) {
    return 0;
  }

  // 오늘이 level > 0이면 1일차부터 시작
  int streak = 1;
  DateTime cursor = todayDate.subtract(const Duration(days: 1));
  int consecutiveZeroDays = 0;

  final earliestSupported =
      DateTime(previousMonth.year, previousMonth.month, 1);

  while (true) {
    // 범위를 벗어나면 종료
    if (cursor.isBefore(earliestSupported) &&
        !byDate.containsKey(_formatDate(cursor))) {
      break;
    }

    final level = byDate[_formatDate(cursor)] ?? 0;

    if (level > 0) {
      // 공부한 날이면 streak 증가하고 연속 0일 카운터 리셋
      streak++;
      consecutiveZeroDays = 0;
    } else {
      // level이 0이면 연속 0일 카운터 증가
      consecutiveZeroDays++;

      // 연속으로 2일 이상 level이 0이면 종료
      if (consecutiveZeroDays >= 2) {
        break;
      }
    }

    cursor = cursor.subtract(const Duration(days: 1));
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


