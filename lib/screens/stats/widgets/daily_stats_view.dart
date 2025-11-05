import 'package:flutter/material.dart';
import 'package:geumpumta/screens/stats/widgets/date_navigation.dart';
import 'package:geumpumta/screens/stats/widgets/stats_card.dart';
import 'package:geumpumta/screens/stats/widgets/continuous_study_section.dart';
import 'package:geumpumta/screens/stats/widgets/usage_time_chart_section.dart';
import 'package:geumpumta/screens/stats/widgets/motivational_message.dart';

class DailyStatsView extends StatefulWidget {
  const DailyStatsView({super.key});

  @override
  State<DailyStatsView> createState() => _DailyStatsViewState();
}

class _DailyStatsViewState extends State<DailyStatsView> {
  DateTime _selectedDate = DateTime(2025, 9, 25);

  // 통계 데이터 (추후 Provider로 관리하면 될 듯..?)
  final List<StatItem> _stats = const [
    StatItem(label: '총 공부 시간', value: '16:00:14'),
    StatItem(label: '최대 집중 시간', value: '10:00:58'),
    StatItem(label: '집중 시간 합계', value: '16:00:14'),
  ];

  void _previousDate() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _nextDate() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 날짜 네비게이션
          DateNavigation(
            selectedDate: _selectedDate,
            onPreviousDate: _previousDate,
            onNextDate: _nextDate,
          ),
          const SizedBox(height: 16),
          
          // 통계 카드
          StatsCard(stats: _stats),
          const SizedBox(height: 24),
          
          // 연속 공부 현황
          const ContinuousStudySection(streakDays: 7),
          const SizedBox(height: 24),
          
          // 오늘의 사용 시간 그래프
          const UsageTimeChartSection(),
          const SizedBox(height: 24),
          
          // 하단 메시지
          const MotivationalMessage(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

