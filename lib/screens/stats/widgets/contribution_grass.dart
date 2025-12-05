import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/stats/grass_statistics.dart';
import 'package:geumpumta/viewmodel/stats/grass_stats_viewmodel.dart';

class ContributionGrass extends ConsumerWidget {
  const ContributionGrass({
    super.key,
    required this.selectedMonth,
    required this.onChangeMonth,
    this.targetUserId,
  });

  final DateTime selectedMonth;
  final int? targetUserId;

  final ValueChanged<DateTime> onChangeMonth;

  static const List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime currentMonth = selectedMonth;

    final minDate = DateTime(2025, 11, 1);
    final now = DateTime.now();
    final maxDate = DateTime(now.year, now.month, 1);

    final prevMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    final nextMonth = DateTime(currentMonth.year, currentMonth.month + 1);

    final canGoPrev = !prevMonth.isBefore(minDate);
    final canGoNext = !nextMonth.isAfter(maxDate);

    final grassState = ref.watch(
      grassStatisticsProvider((currentMonth, targetUserId)),
    );

    final monthName = _monthNames[currentMonth.month - 1];

    final daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final firstDayOfWeek =
        DateTime(currentMonth.year, currentMonth.month, 1).weekday;

    final totalCells = 5 * 7;
    final startOffset = firstDayOfWeek - 1;

    final Map<int, int> levelByDay = {};
    grassState.whenOrNull(
      data: (GrassStatistics stats) {
        for (final entry in stats.entries) {
          if (entry.date.year == currentMonth.year &&
              entry.date.month == currentMonth.month) {
            levelByDay[entry.date.day] = entry.level;
          }
        }
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: canGoPrev ? () => onChangeMonth(prevMonth) : null,
              child: Icon(
                Icons.chevron_left,
                size: 20,
                color: canGoPrev ? const Color(0xFF999999) : Colors.grey.shade300,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              monthName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: canGoNext ? () => onChangeMonth(nextMonth) : null,
              child: Icon(
                Icons.chevron_right,
                size: 20,
                color: canGoNext ? const Color(0xFF999999) : Colors.grey.shade300,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Center(
          child: SizedBox(
            width: 7 * (12.0 + 4),
            height: 5 * (12.0 + 4),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemCount: totalCells,
              itemBuilder: (context, index) {
                if (index < startOffset || index >= startOffset + daysInMonth) {
                  return Container();
                }
                final day = index - startOffset + 1;
                final level = levelByDay[day] ?? 0;
                return _buildGrassDot(level);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGrassDot(int level) {
    Color dotColor;

    switch (level) {
      case 0:
        dotColor = const Color(0xFFEBEDF0);
        break;
      case 1:
        dotColor = const Color(0xFFE3F2FD);
        break;
      case 2:
        dotColor = const Color(0xFF90CAF9);
        break;
      case 3:
        dotColor = const Color(0xFF42A5F5);
        break;
      case 4:
      default:
        dotColor = const Color(0xFF0BAEFF);
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: dotColor,
        borderRadius: BorderRadius.zero,
      ),
    );
  }
}
