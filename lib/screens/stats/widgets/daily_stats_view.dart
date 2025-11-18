import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/stats/daily_statistics.dart';
import 'package:geumpumta/screens/stats/widgets/continuous_study_section.dart';
import 'package:geumpumta/screens/stats/widgets/date_navigation.dart';
import 'package:geumpumta/screens/stats/widgets/motivational_message.dart';
import 'package:geumpumta/screens/stats/widgets/stats_card.dart';
import 'package:geumpumta/screens/stats/widgets/usage_time_chart_section.dart';
import 'package:geumpumta/viewmodel/stats/daily_stats_viewmodel.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchDailyStats());
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
      child: dailyState.when(
        data: (stats) => _buildContent(stats),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Icon(
              Icons.error_outline,
              color: Color(0xFFFF6B6B),
              size: 40,
            ),
            const SizedBox(height: 12),
            const Text(
              '일간 통계를 불러오지 못했습니다.\n잠시 후 다시 시도해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 16),
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
      ),
    );
  }

  Widget _buildContent(DailyStatistics stats) {
    final statItems = [
      StatItem(
        label: '총 공부 시간',
        value: _formatDuration(stats.totalStudySeconds),
      ),
      StatItem(
        label: '최대 집중 시간',
        value: _formatDuration(stats.maxFocusSeconds),
      ),
      StatItem(
        label: '집중 시간 합계',
        value: _formatDuration(stats.totalStudySeconds),
      ),
    ];

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateNavigation(
            selectedDate: _selectedDate,
            onPreviousDate: _previousDate,
            onNextDate: _nextDate,
          ),
          const SizedBox(height: 16),
        StatsCard(stats: statItems),
          const SizedBox(height: 24),
        const ContinuousStudySection(),
          const SizedBox(height: 24),
        UsageTimeChartSection(slots: stats.slots),
          const SizedBox(height: 24),
          const MotivationalMessage(),
          const SizedBox(height: 40),
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
}

