import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/stats/daily_statistics.dart';
import 'package:geumpumta/screens/stats/widgets/continuous_study_section.dart';
import 'package:geumpumta/screens/stats/widgets/date_navigation.dart';
import 'package:geumpumta/screens/stats/widgets/motivational_message.dart';
import 'package:geumpumta/screens/stats/widgets/usage_time_chart_section.dart';
import 'package:geumpumta/viewmodel/stats/daily_stats_viewmodel.dart';
import 'package:geumpumta/viewmodel/stats/grass_stats_viewmodel.dart';

class DailyStatsView extends ConsumerStatefulWidget {
  const DailyStatsView({super.key});

  @override
  ConsumerState<DailyStatsView> createState() => _DailyStatsViewState();
}

class _DailyStatsViewState extends ConsumerState<DailyStatsView> {
  DateTime _selectedDate = DateTime.now();

  void _previousDate() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
    _fetchDailyStats();
  }

  void _nextDate() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
    _fetchDailyStats();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDailyStats();
      // 연속공부현황 provider 새로고침
      ref.refresh(currentStreakProvider(null));
    });
  }

  void _fetchDailyStats() {
    final formatted = _formatDateForApi(_selectedDate);
    ref
        .read(dailyStatsViewModelProvider.notifier)
        .loadDailyStatistics(date: formatted);
  }

  @override
  Widget build(BuildContext context) {
    final dailyState = ref.watch(dailyStatsViewModelProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateNavigation(
            selectedDate: _selectedDate,
            onPreviousDate: _previousDate,
            onNextDate: _nextDate,
            minDate: DateTime(2025, 11, 1),
          ),
          const SizedBox(height: 16),
          _buildDailyStatsCard(dailyState),
          const SizedBox(height: 24),
          ContinuousStudySection(selectedDate: _selectedDate),
          const SizedBox(height: 24),
          _buildUsageTimeChart(dailyState),
          const SizedBox(height: 24),
          _buildMotivationalMessage(dailyState),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDailyStatsCard(AsyncValue<DailyStatistics> state) {
    return state.when(
      data: (stats) => _buildStatsContainer(
        children: [
          _buildStatRow('총 공부 시간', _formatDuration(stats.totalStudySeconds)),
          const SizedBox(height: 12),
          _buildStatRow('최대 집중 시간', _formatDuration(stats.maxFocusSeconds)),
          const SizedBox(height: 12),
          _buildStatRow('집중 시간 합계', _formatDuration(stats.totalStudySeconds)),
        ],
      ),
      loading: () => _buildStatsContainer(
        children: [
          _buildLoadingRow('총 공부 시간'),
          const SizedBox(height: 12),
          _buildLoadingRow('최대 집중 시간'),
          const SizedBox(height: 12),
          _buildLoadingRow('집중 시간 합계'),
        ],
      ),
      error: (error, _) => _buildStatsContainer(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFFF6B6B), size: 28),
          const SizedBox(height: 12),
          const Text(
            '일간 통계를 불러오지 못했습니다.\n잠시 후 다시 시도해주세요.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _fetchDailyStats,
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

  Widget _buildUsageTimeChart(AsyncValue<DailyStatistics> state) {
    return state.when(
      data: (stats) => UsageTimeChartSection(slots: stats.slots),
      loading: () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: const Center(
          child: Text(
            '차트를 불러오지 못했습니다.',
            style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
        ),
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
          style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
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
          style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
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

  Widget _buildMotivationalMessage(AsyncValue<DailyStatistics> state) {
    return state.when(
      data: (stats) {
        // 12시간 = 43200초
        const targetSeconds = 12 * 3600;
        final missedSeconds = targetSeconds - stats.totalStudySeconds;
        final missedDuration = Duration(
          seconds: missedSeconds < 0 ? 0 : missedSeconds,
        );
        final hours = missedDuration.inHours.toString().padLeft(2, '0');
        final minutes = (missedDuration.inMinutes % 60).toString().padLeft(
          2,
          '0',
        );
        final secs = (missedDuration.inSeconds % 60).toString().padLeft(2, '0');
        final missedTime = '$hours:$minutes:$secs';

        return MotivationalMessage(
          missedTime: missedTime,
          message: '집중력을 높여보세요!',
        );
      },
      loading: () => const MotivationalMessage(),
      error: (_, __) => const MotivationalMessage(),
    );
  }
}
