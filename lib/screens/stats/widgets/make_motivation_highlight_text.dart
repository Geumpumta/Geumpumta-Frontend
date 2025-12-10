import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/stats/grass_statistics.dart';
import 'package:geumpumta/screens/ranking/ranking.dart';
import 'package:geumpumta/screens/stats/widgets/build_motivation_content_with_highlight.dart';
import 'package:geumpumta/viewmodel/stats/grass_stats_viewmodel.dart';

class MakeMotivationHighlightText extends ConsumerWidget {
  const MakeMotivationHighlightText({
    super.key,
    required this.periodOption,
    required this.selectedDate,
    this.targetUserId,
  });

  final PeriodOption periodOption;
  final DateTime selectedDate;
  final int? targetUserId;

  DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime _startOfWeek(DateTime d) {
    return _normalize(d.subtract(Duration(days: d.weekday - 1)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveDate = (periodOption == PeriodOption.weekly)
        ? _startOfWeek(selectedDate)
        : selectedDate;

    final grassThisMonth = ref.watch(
      grassStatisticsProvider((effectiveDate, targetUserId)),
    );
    final grassNextMonth = ref.watch(
      grassStatisticsProvider((_nextMonth(effectiveDate), targetUserId)),
    );

    if (grassThisMonth.isLoading || grassNextMonth.isLoading) {
      return const BuildMotivationContentWithHighlight(
        icon: Icons.local_fire_department,
        text: "데이터를 불러오는 중...",
        highlightText: "",
      );
    }

    if (grassThisMonth.hasError || grassNextMonth.hasError) {
      return const BuildMotivationContentWithHighlight(
        icon: Icons.local_fire_department,
        text: "학습 데이터를 불러오지 못했습니다.",
        highlightText: "",
      );
    }

    final thisMonth = grassThisMonth.asData?.value;
    final nextMonth = grassNextMonth.asData?.value;

    if (thisMonth == null || nextMonth == null) {
      return const BuildMotivationContentWithHighlight(
        icon: Icons.local_fire_department,
        text: "기록된 공부 시간이 없어요!",
        highlightText: "",
      );
    }

    final highlight = getHighlightText(ref, effectiveDate);

    if (highlight.trim().isEmpty) {
      return const BuildMotivationContentWithHighlight(
        icon: Icons.local_fire_department,
        text: "기록된 공부 시간이 없어요!",
        highlightText: "",
      );
    }

    final titleText = periodOption == PeriodOption.weekly
        ? "이번 주 가장 열심히 한 날은 "
        : "이번 달 가장 열심히 한 날은 ";

    return BuildMotivationContentWithHighlight(
      icon: Icons.local_fire_department,
      text: titleText,
      highlightText: highlight,
    );
  }

  String getHighlightText(WidgetRef ref, DateTime effectiveDate) {
    final grassThisMonth = ref.read(
      grassStatisticsProvider((effectiveDate, targetUserId)),
    );
    final grassNextMonth = ref.read(
      grassStatisticsProvider((_nextMonth(effectiveDate), targetUserId)),
    );

    if (grassThisMonth.isLoading || grassNextMonth.isLoading) return "";
    if (grassThisMonth.hasError || grassNextMonth.hasError) return "";

    final thisMonth = grassThisMonth.asData?.value;
    final nextMonth = grassNextMonth.asData?.value;

    if (thisMonth == null || nextMonth == null) return "";

    if (periodOption == PeriodOption.weekly) {
      return _bestDayWeekly(thisMonth, nextMonth, effectiveDate) ?? "";
    } else {
      return _bestDayMonthly(thisMonth, effectiveDate) ?? "";
    }
  }

  String? _bestDayWeekly(
      GrassStatistics thisMonth,
      GrassStatistics nextMonth,
      DateTime weekStart,
      ) {
    final ws = _normalize(weekStart);
    final we = _normalize(weekStart.add(const Duration(days: 6)));

    final entries = [...thisMonth.entries, ...nextMonth.entries];

    final filtered = entries.where((e) {
      final d = _normalize(e.date);
      return (d.isAtSameMomentAs(ws) || d.isAfter(ws)) &&
          (d.isAtSameMomentAs(we) || d.isBefore(we)) &&
          e.level > 0;
    }).toList();

    if (filtered.isEmpty) return null;

    filtered.sort((a, b) {
      if (b.level != a.level) return b.level.compareTo(a.level);
      return a.date.compareTo(b.date);
    });

    return _weekdayLabel(filtered.first.date.weekday);
  }

  String? _bestDayMonthly(GrassStatistics stats, DateTime month) {
    final filtered = stats.entries.where((e) {
      return e.date.year == month.year &&
          e.date.month == month.month &&
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
    return date.month == 12
        ? DateTime(date.year + 1, 1, 1)
        : DateTime(date.year, date.month + 1, 1);
  }
}
