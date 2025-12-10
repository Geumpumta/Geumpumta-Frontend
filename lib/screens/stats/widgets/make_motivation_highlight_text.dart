import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/stats/grass_statistics.dart';
import 'package:geumpumta/screens/ranking/ranking.dart';
import 'package:geumpumta/viewmodel/stats/grass_stats_viewmodel.dart';

class MakeMotivationHighlightText extends ConsumerWidget {
  const MakeMotivationHighlightText({
    super.key,
    required this.periodOption,
    required this.selectedDate,
  });

  final PeriodOption periodOption;
  final DateTime selectedDate;

  String getHighlightText(WidgetRef ref) {
    final grassThisMonth = ref.read(
      grassStatisticsProvider((selectedDate, null)),
    );
    final grassNextMonth = ref.read(
      grassStatisticsProvider((_nextMonth(selectedDate), null)),
    );

    if (grassThisMonth.isLoading || grassNextMonth.isLoading) return "";
    if (grassThisMonth.hasError || grassNextMonth.hasError) return "";

    final thisMonth = grassThisMonth.asData?.value;
    final nextMonth = grassNextMonth.asData?.value;

    if (thisMonth == null || nextMonth == null) return "";

    if (periodOption == PeriodOption.weekly) {
      return _getWeeklyBestDay(thisMonth, nextMonth, selectedDate) ?? "";
    } else if (periodOption == PeriodOption.monthly) {
      return _getMonthlyBestDay(thisMonth, selectedDate) ?? "";
    }

    return "";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(getHighlightText(ref));
  }

  String? _getWeeklyBestDay(
      GrassStatistics thisMonth,
      GrassStatistics nextMonth,
      DateTime weekStart,
      ) {
    final weekEnd = weekStart.add(const Duration(days: 6));

    final entries = [
      ...thisMonth.entries,
      ...nextMonth.entries,
    ];

    final filtered = entries.where((e) {
      return !e.date.isBefore(weekStart) &&
          !e.date.isAfter(weekEnd) &&
          e.level > 0;
    }).toList();

    if (filtered.isEmpty) return null;

    filtered.sort((a, b) {
      if (b.level != a.level) return b.level.compareTo(a.level);
      return a.date.compareTo(b.date);
    });

    return _weekdayLabel(filtered.first.date.weekday);
  }

  String? _getMonthlyBestDay(
      GrassStatistics stats,
      DateTime selectedMonth,
      ) {
    final filtered = stats.entries.where((e) {
      return e.date.year == selectedMonth.year &&
          e.date.month == selectedMonth.month &&
          e.level > 0;
    }).toList();

    if (filtered.isEmpty) return null;

    filtered.sort((a, b) {
      if (b.level != a.level) return b.level.compareTo(a.level);
      return a.date.compareTo(b.date);
    });

    return "${filtered.first.date.day}일";
  }

  String _weekdayLabel(int weekday) {
    const labels = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"];
    return labels[(weekday - 1) % 7];
  }

  static DateTime _nextMonth(DateTime date) {
    if (date.month == 12) {
      return DateTime(date.year + 1, 1, 1);
    }
    return DateTime(date.year, date.month + 1, 1);
  }
}
