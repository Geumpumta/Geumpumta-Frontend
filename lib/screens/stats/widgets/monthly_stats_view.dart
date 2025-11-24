import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/stats/grass_statistics.dart';
import 'package:geumpumta/models/entity/stats/monthly_statistics.dart';
import 'package:geumpumta/screens/stats/widgets/continuous_study_section.dart';
import 'package:geumpumta/viewmodel/stats/grass_stats_viewmodel.dart';
import 'package:geumpumta/viewmodel/stats/monthly_stats_viewmodel.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchMonthlyStats());
  }

  void _fetchMonthlyStats() {
    final formattedDate = _formatDateForApi(_selectedMonth);
    ref
        .read(monthlyStatsViewModelProvider.notifier)
        .loadMonthlyStatistics(date: formattedDate);
  }

  DateTime _getPreviousMonth(DateTime date) {
    if (date.month == 1) {
      return DateTime(date.year - 1, 12);
    }
    return DateTime(date.year, date.month - 1);
  }

  DateTime _getNextMonth(DateTime date) {
    if (date.month == 12) {
      return DateTime(date.year + 1, 1);
    }
    return DateTime(date.year, date.month + 1);
  }

  @override
  Widget build(BuildContext context) {
    final monthlyStatsState = ref.watch(monthlyStatsViewModelProvider);
    final grassState = ref.watch(grassStatisticsProvider(_selectedMonth));
    final daysInMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthNavigation(),
          const SizedBox(height: 16),
          _buildMonthlyStatsCard(monthlyStatsState, daysInMonth),
          const SizedBox(height: 24),
          const ContinuousStudySection(),
          const SizedBox(height: 24),
          _buildMotivationalMessage(monthlyStatsState, grassState),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMonthNavigation() {
    final monthStr = '${_selectedMonth.year}년 ${_selectedMonth.month}월';

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
                _selectedMonth = _getPreviousMonth(_selectedMonth);
              });
              _fetchMonthlyStats();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: Color(0xFF666666),
            ),
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
            onTap: () {
              setState(() {
                _selectedMonth = _getNextMonth(_selectedMonth);
              });
              _fetchMonthlyStats();
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

  Widget _buildMonthlyStatsCard(
    AsyncValue<MonthlyStatistics> state,
    int daysInMonth,
  ) {
    return state.when(
      data: (stats) => _buildStatsContainer(
        children: [
          _buildStatRow(
            '월간 총 공부 시간',
            _formatDuration(stats.totalMonthlySeconds),
          ),
          const SizedBox(height: 12),
          _buildStatRow(
            '평균 공부 시간',
            _formatDuration(stats.averageDailySeconds),
          ),
          const SizedBox(height: 12),
          _buildStatRow(
            '이번 달 공부 일 수',
            '${stats.studiedDays} / $daysInMonth',
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
          _buildLoadingRow('월간 총 공부 시간'),
          const SizedBox(height: 12),
          _buildLoadingRow('평균 공부 시간'),
          const SizedBox(height: 12),
          _buildLoadingRow('이번 달 공부 일 수'),
        ],
      ),
      error: (error, _) => _buildStatsContainer(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFFF6B6B),
            size: 28,
          ),
          const SizedBox(height: 12),
          const Text(
            '월간 통계를 불러오지 못했습니다.\n잠시 후 다시 시도해주세요.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _fetchMonthlyStats,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0BAEFF),
              foregroundColor: Colors.white,
            ),
            child: const Text('다시 시도'),
          ),
        ],
      ),
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

  Widget _buildMotivationalMessage(
    AsyncValue<MonthlyStatistics> monthlyState,
    AsyncValue<GrassStatistics> grassState,
  ) {
    final monthlyStats = monthlyState.asData?.value;
    if (monthlyStats == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (monthlyStats.totalMonthlySeconds == 0) {
      return _buildMotivationContent(
        icon: Icons.emoji_events,
        lines: const [
          '이번달에 기록된 학습시간이 없어요!\n타이머 기능을 통해 학습시간을 측정해보세요.',
        ],
      );
    }

    if (grassState.isLoading) {
      return _buildMotivationContent(
        icon: Icons.hourglass_bottom,
        lines: const ['잔디 데이터를 불러오는 중입니다...'],
      );
    }

    if (grassState.hasError) {
      return _buildMotivationContent(
        icon: Icons.error_outline,
        lines: const ['잔디 데이터를 불러오지 못했습니다.'],
      );
    }

    final grass = grassState.asData?.value;
    final bestEntry = _findBestMonthlyEntry(grass);

    if (bestEntry == null) {
      return _buildMotivationContent(
        icon: Icons.emoji_events,
        lines: const [
          '이번달에 기록된 학습시간이 없어요!\n타이머 기능을 통해 학습시간을 측정해보세요.',
        ],
      );
    }

    return _buildMotivationContentWithHighlight(
      icon: Icons.emoji_events,
      text: '이번 달 가장 열심히 한 날은 ',
      highlightText: '${bestEntry.date.day}일',
    );
  }

  GrassEntry? _findBestMonthlyEntry(GrassStatistics? stats) {
    if (stats == null) return null;
    final entries = stats.entries
        .where((entry) =>
            entry.date.year == _selectedMonth.year &&
            entry.date.month == _selectedMonth.month &&
            entry.level > 0)
        .toList();
    if (entries.isEmpty) return null;
    entries.sort((a, b) {
      if (b.level != a.level) {
        return b.level.compareTo(a.level);
      }
      return a.date.compareTo(b.date);
    });
    return entries.first;
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

  Widget _buildMotivationContentWithHighlight({
    required IconData icon,
    required String text,
    required String highlightText,
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
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
              ),
              children: [
                TextSpan(text: text),
                TextSpan(
                  text: highlightText,
                  style: const TextStyle(
                    color: Color(0xFF0BAEFF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
    return '${date.year}-$month-01';
  }
}


