import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/stats/monthly_statistics.dart';
import 'package:geumpumta/screens/stats/widgets/continuous_study_section.dart';
import 'package:geumpumta/screens/stats/widgets/make_motivation_highlight_text.dart';
import 'package:geumpumta/viewmodel/stats/grass_stats_viewmodel.dart';
import 'package:geumpumta/viewmodel/stats/monthly_stats_viewmodel.dart';

import '../../ranking/widgets/period_option.dart';

class MonthlyStatsView extends ConsumerStatefulWidget {
  const MonthlyStatsView({super.key});

  @override
  ConsumerState<MonthlyStatsView> createState() => _MonthlyStatsViewState();
}

class _MonthlyStatsViewState extends ConsumerState<MonthlyStatsView> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMonthlyStats();
      ref.refresh(currentStreakProvider(null));
    });
  }

  void _fetchMonthlyStats() {
    ref
        .read(monthlyStatsViewModelProvider.notifier)
        .loadMonthlyStatistics(date: _formatDateForApi(_selectedMonth));
  }

  DateTime _getPreviousMonth(DateTime date) => date.month == 1
      ? DateTime(date.year - 1, 12)
      : DateTime(date.year, date.month - 1);

  DateTime _getNextMonth(DateTime date) => date.month == 12
      ? DateTime(date.year + 1, 1)
      : DateTime(date.year, date.month + 1);

  @override
  Widget build(BuildContext context) {
    final monthlyStatsState = ref.watch(monthlyStatsViewModelProvider);

    final daysInMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    ).day;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthNavigation(),
          const SizedBox(height: 16),
          _buildMonthlyStatsCard(monthlyStatsState, daysInMonth),
          const SizedBox(height: 24),

          ContinuousStudySection(selectedDate: _selectedMonth),
          const SizedBox(height: 24),

          MakeMotivationHighlightText(
            periodOption: PeriodOption.monthly,
            selectedDate: _selectedMonth,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMonthNavigation() {
    final monthStr = "${_selectedMonth.year}년 ${_selectedMonth.month}월";

    final minDate = DateTime(2025, 11, 1);
    final today = DateTime(DateTime.now().year, DateTime.now().month);

    final prevMonth = _getPreviousMonth(_selectedMonth);
    final nextMonth = _getNextMonth(_selectedMonth);

    final canGoPrev = !prevMonth.isBefore(minDate);
    final canGoNext = !nextMonth.isAfter(today);

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
                _selectedMonth = prevMonth;
              });
              _fetchMonthlyStats();
            }
                : null,
            child: Icon(Icons.arrow_back_ios,
                size: 16,
                color: canGoPrev ? const Color(0xFF666666) : Colors.grey.shade300),
          ),
          Text(
            monthStr,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: canGoNext
                ? () {
              setState(() {
                _selectedMonth = nextMonth;
              });
              _fetchMonthlyStats();
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

  Widget _buildMonthlyStatsCard(
      AsyncValue<MonthlyStatistics> state,
      int daysInMonth,
      ) {
    return state.when(
      data: (stats) => _buildStatsContainer(
        children: [
          _buildStatRow("월간 총 공부 시간", _formatDuration(stats.totalMonthSeconds)),
          const SizedBox(height: 12),
          _buildStatRow("평균 공부 시간", _formatDuration(stats.averageDailySeconds)),
          const SizedBox(height: 12),
          _buildStatRow("이번 달 공부 일 수", "${stats.studiedDays} / $daysInMonth"),
          const SizedBox(height: 12),
          _buildStatRow("최대 연속 공부 일수", "${stats.maxConsecutiveStudyDays}일"),
        ],
      ),
      loading: () => _buildStatsContainer(
        children: [
          _buildLoadingRow("월간 총 공부 시간"),
          const SizedBox(height: 12),
          _buildLoadingRow("평균 공부 시간"),
          const SizedBox(height: 12),
          _buildLoadingRow("이번 달 공부 일 수"),
        ],
      ),
      error: (_, __) => _buildStatsContainer(
        children: [
          const Icon(Icons.error_outline, size: 28, color: Color(0xFFFF6B6B)),
          const SizedBox(height: 12),
          const Text(
            "월간 통계를 불러오지 못했습니다.\n잠시 후 다시 시도해주세요.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _fetchMonthlyStats,
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
        borderRadius: BorderRadius.circular(12),
      ),
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
        Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF333333))),
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

  String _formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
    return "${d.inHours.toString().padLeft(2, '0')}:"
        "${(d.inMinutes % 60).toString().padLeft(2, '0')}:"
        "${(d.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  String _formatDateForApi(DateTime d) {
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-01";
  }
}
