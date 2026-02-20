import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/stats/weekly_statistics.dart';
import 'package:geumpumta/screens/stats/widgets/continuous_study_section.dart';
import 'package:geumpumta/screens/stats/widgets/make_motivation_highlight_text.dart';
import 'package:geumpumta/viewmodel/stats/weekly_stats_viewmodel.dart';
import 'package:geumpumta/viewmodel/stats/grass_stats_viewmodel.dart';

import '../../ranking/widgets/period_option.dart';

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
      ref.refresh(currentStreakProvider(null));
    });
  }

  DateTime _startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  void _fetchWeeklyStats() {
    final formattedDate = _formatDateForApi(_selectedWeekStart);
    ref.read(weeklyStatsViewModelProvider.notifier)
        .loadWeeklyStatistics(date: formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    final weeklyStatsState = ref.watch(weeklyStatsViewModelProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWeekNavigation(),
          const SizedBox(height: 16),
          _buildWeeklyStatsCard(weeklyStatsState),
          const SizedBox(height: 24),
          ContinuousStudySection(selectedDate: _selectedWeekStart),
          const SizedBox(height: 24),

          MakeMotivationHighlightText(
            periodOption: PeriodOption.weekly,
            selectedDate: _selectedWeekStart,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildWeekNavigation() {
    final weekStr = _getWeekRangeString(_selectedWeekStart);

    final minDate = DateTime(2025, 11, 1);
    final today = DateTime.now();

    final nextWeek = _nextWeek(_selectedWeekStart);
    final prevWeek = _previousWeek(_selectedWeekStart);

    final canGoPrev = !prevWeek.isBefore(minDate);
    final canGoNext = !nextWeek.isAfter(today);

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
            onTap: canGoPrev
                ? () {
              setState(() {
                _selectedWeekStart = prevWeek;
              });
              _fetchWeeklyStats();
            }
                : null,
            child: Icon(Icons.arrow_back_ios,
                size: 16,
                color: canGoPrev ? const Color(0xFF666666) : Colors.grey.shade300),
          ),

          Text(
            weekStr,
            style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
                fontWeight: FontWeight.w500),
          ),

          GestureDetector(
            onTap: canGoNext
                ? () {
              setState(() {
                _selectedWeekStart = nextWeek;
              });
              _fetchWeeklyStats();
            }
                : null,
            child: Icon(Icons.arrow_forward_ios,
                size: 16,
                color: canGoNext ? const Color(0xFF666666) : Colors.grey.shade300),
          ),
        ],
      ),
    );
  }

  DateTime _previousWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday + 6));
  }

  DateTime _nextWeek(DateTime date) {
    return date.add(Duration(days: 8 - date.weekday));
  }

  Widget _buildWeeklyStatsCard(AsyncValue<WeeklyStatistics> state) {
    return state.when(
      data: (stats) => _buildStatsContainer(
        children: [
          _buildStatRow("주간 총 공부 시간", _formatDuration(stats.totalWeekSeconds)),
          const SizedBox(height: 12),
          _buildStatRow("평균 공부 시간", _formatDuration(stats.averageDailySeconds)),
          const SizedBox(height: 12),
          _buildStatRow("최대 연속 공부 일수", "${stats.maxConsecutiveStudyDays}일"),
        ],
      ),
      loading: () => _buildStatsContainer(
        children: [
          _buildLoadingRow("주간 총 공부 시간"),
          const SizedBox(height: 12),
          _buildLoadingRow("평균 공부 시간"),
        ],
      ),
      error: (_, __) => _buildStatsContainer(
        children: [
          const Icon(Icons.error_outline, size: 28, color: Color(0xFFFF6B6B)),
          const SizedBox(height: 12),
          const Text(
            "주간 통계를 불러오지 못했습니다.\n잠시 후 다시 시도해주세요.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _fetchWeeklyStats,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0BAEFF),
              foregroundColor: Colors.white,
            ),
            child: const Text("다시 시도"),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsContainer({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12)),
      child: Column(children: children),
    );
  }

  Widget _buildLoadingRow(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF333333))),
        Container(
          width: 80,
          height: 16,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildStatRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333))),
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF0BAEFF),
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
    return "${d.inHours.toString().padLeft(2, '0')}:"
        "${(d.inMinutes % 60).toString().padLeft(2, '0')}:"
        "${(d.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  String _formatDateForApi(DateTime d) {
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  String _getWeekRangeString(DateTime weekStart) {
    final year = weekStart.year;
    final month = weekStart.month;

    final firstDay = DateTime(year, month, 1);
    final firstMonday =
    firstDay.weekday == 1 ? firstDay : firstDay.add(Duration(days: 8 - firstDay.weekday));

    final weekNumber = ((weekStart.difference(firstMonday).inDays) ~/ 7) + 1;

    return "$year년 $month월 ${weekNumber <= 0 ? 1 : weekNumber}주";
  }
}
