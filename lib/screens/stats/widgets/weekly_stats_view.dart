import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/stats/grass_statistics.dart';
import 'package:geumpumta/models/entity/stats/weekly_statistics.dart';
import 'package:geumpumta/screens/stats/widgets/continuous_study_section.dart';
import 'package:geumpumta/viewmodel/stats/grass_stats_viewmodel.dart';
import 'package:geumpumta/viewmodel/stats/weekly_stats_viewmodel.dart';

class WeeklyStatsView extends ConsumerStatefulWidget {
  const WeeklyStatsView({super.key});

  @override
  ConsumerState<WeeklyStatsView> createState() => _WeeklyStatsViewState();
}

class _WeeklyStatsViewState extends ConsumerState<WeeklyStatsView> {
  late DateTime _selectedWeekStart;

  @override
  void initState() {
    super.initState();
    _selectedWeekStart = _startOfWeek(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWeeklyStats();
    });
  }

  DateTime _startOfWeek(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  DateTime _addMonth(DateTime date) {
    final year = date.month == 12 ? date.year + 1 : date.year;
    final month = date.month == 12 ? 1 : date.month + 1;
    return DateTime(year, month, 1);
  }

  void _fetchWeeklyStats() {
    final formattedDate = _formatDateForApi(_selectedWeekStart);
    ref
        .read(weeklyStatsViewModelProvider.notifier)
        .loadWeeklyStatistics(date: formattedDate);
  }

  String _getWeekRangeString(DateTime weekStart) {
    final month = weekStart.month;
    final year = weekStart.year;

    final firstDayOfMonth = DateTime(year, month, 1);

    int daysFromFirstMonday = 0;
    if (firstDayOfMonth.weekday != 1) {
      daysFromFirstMonday = 8 - firstDayOfMonth.weekday;
    }
    final firstMonday = firstDayOfMonth.add(Duration(days: daysFromFirstMonday));

    final weeksDiff = weekStart.difference(firstMonday).inDays ~/ 7;
    final weekNumber = weeksDiff + 1;

    if (weekNumber <= 0) {
      return '$year년 $month월 1주';
    }

    return '$year년 $month월 $weekNumber주';
  }

  DateTime _getPreviousWeek(DateTime date) {
    int daysFromMonday = date.weekday - 1;
    DateTime monday = date.subtract(Duration(days: daysFromMonday));
    return monday.subtract(const Duration(days: 7));
  }

  DateTime _getNextWeek(DateTime date) {
    int daysFromMonday = date.weekday - 1;
    DateTime monday = date.subtract(Duration(days: daysFromMonday));
    return monday.add(const Duration(days: 7));
  }

  @override
  Widget build(BuildContext context) {
    final weeklyStatsState = ref.watch(weeklyStatsViewModelProvider);
    final grassCurrentMonth =
        ref.watch(grassStatisticsProvider(_selectedWeekStart));
    final grassNextMonth =
        ref.watch(grassStatisticsProvider(_addMonth(_selectedWeekStart)));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWeekNavigation(),
          const SizedBox(height: 16),
          _buildWeeklyStatsCard(weeklyStatsState),
          const SizedBox(height: 24),
          const ContinuousStudySection(),
          const SizedBox(height: 24),
          _buildMotivationalMessage(
            weeklyStatsState,
            grassCurrentMonth,
            grassNextMonth,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildWeekNavigation() {
    final weekStr = _getWeekRangeString(_selectedWeekStart);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedWeekStart = _getPreviousWeek(_selectedWeekStart);
              });
              _fetchWeeklyStats();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: Color(0xFF666666),
            ),
          ),
          Text(
            weekStr,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedWeekStart = _getNextWeek(_selectedWeekStart);
              });
              _fetchWeeklyStats();
            },
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStatsCard(AsyncValue<WeeklyStatistics> state) {
    return state.when(
      data: (stats) => _buildStatsContainer(
        children: [
          _buildStatRow(
            '주간 총 공부 시간',
            _formatDuration(stats.totalWeekSeconds),
          ),
          const SizedBox(height: 12),
          _buildStatRow(
            '평균 공부 시간',
            _formatDuration(stats.averageDailySeconds),
          ),
          const SizedBox(height: 12),
          _buildStatRow(
            '최대 연속 공부 일수',
            '${stats.maxConsecutiveStudyDays}일',
          ),
        ],
      ),
      loading: () => _buildStatsContainer(
        children: [
          _buildLoadingRow('주간 총 공부 시간'),
          const SizedBox(height: 12),
          _buildLoadingRow('평균 공부 시간'),
        ],
      ),
      error: (error, _) {
        return _buildStatsContainer(
          children: [
            const Icon(
              Icons.error_outline,
              color: Color(0xFFFF6B6B),
              size: 28,
            ),
            const SizedBox(height: 12),
            Text(
              '주간 통계를 불러오지 못했습니다.\n잠시 후 다시 시도해주세요.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _fetchWeeklyStats,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0BAEFF),
                foregroundColor: Colors.white,
              ),
              child: const Text('다시 시도'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsContainer({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildLoadingRow(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
          ),
        ),
        Container(
          width: 80,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF0BAEFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  GrassEntry? _findBestEntryForRange(
    List<GrassEntry> entries,
    DateTime start,
    DateTime end,
  ) {
    final filtered = entries.where((entry) {
      return !entry.date.isBefore(start) &&
          !entry.date.isAfter(end) &&
          entry.level > 0;
    }).toList();

    if (filtered.isEmpty) return null;

    filtered.sort((a, b) {
      if (b.level != a.level) {
        return b.level.compareTo(a.level);
      }
      return a.date.compareTo(b.date);
    });
    return filtered.first;
  }

  String _weekdayLabel(int weekday) {
    const labels = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    return labels[(weekday - 1) % labels.length];
  }

  Widget _buildMotivationContent({
    required IconData icon,
    required List<String> lines,
  }) {
    return Center(
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF0BAEFF),
            size: 32,
          ),
          const SizedBox(height: 12),
          for (final line in lines)
            Text(
              line,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMotivationalMessage(
    AsyncValue<WeeklyStatistics> weeklyState,
    AsyncValue<GrassStatistics> currentMonth,
    AsyncValue<GrassStatistics> nextMonth,
  ) {
    final weeklyStats = weeklyState.asData?.value;
    if (weeklyStats == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (weeklyStats.totalWeekSeconds == 0) {
      return _buildMotivationContent(
        icon: Icons.local_fire_department,
        lines: const [
          '이번주에 기록된 학습시간이 없어요!\n타이머 기능을 통해 학습시간을 측정해보세요.',
        ],
      );
    }

    if (currentMonth.isLoading || nextMonth.isLoading) {
      return _buildMotivationContent(
        icon: Icons.hourglass_bottom,
        lines: const ['잔디 데이터를 불러오는 중입니다...'],
      );
    }

    if (currentMonth.hasError || nextMonth.hasError) {
      return _buildMotivationContent(
        icon: Icons.error_outline,
        lines: const ['잔디 데이터를 불러오지 못했습니다.'],
      );
    }

    final weekStart = _selectedWeekStart;
    final weekEnd = weekStart.add(const Duration(days: 6));
    final bestEntry = _findBestEntryForRange(
      [currentMonth.asData?.value, nextMonth.asData?.value]
          .whereType<GrassStatistics>()
          .expand((stats) => stats.entries)
          .toList(),
      weekStart,
      weekEnd,
    );

    if (bestEntry == null) {
      return _buildMotivationContent(
        icon: Icons.local_fire_department,
        lines: const [
          '이번주에 기록된 학습시간이 없어요!\n타이머 기능을 통해 학습시간을 측정해보세요.',
        ],
      );
    }

    final weekdayLabel = _weekdayLabel(bestEntry.date.weekday);
    return _buildMotivationContent(
      icon: Icons.local_fire_department,
      lines: ['이번 주 가장 열심히 한 날은 $weekdayLabel 입니다'],
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final secs = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  String _formatDateForApi(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}


