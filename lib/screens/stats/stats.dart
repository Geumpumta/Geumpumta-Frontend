import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/screens/stats/widgets/daily_stats_view.dart';
import 'package:geumpumta/screens/stats/widgets/weekly_stats_view.dart';
import 'package:geumpumta/screens/stats/widgets/monthly_stats_view.dart';
import 'package:geumpumta/screens/stats/widgets/period_selector.dart';
import 'package:geumpumta/viewmodel/stats/grass_stats_viewmodel.dart';
import 'package:geumpumta/widgets/text_header/text_header.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  StatsPeriodOption _selectedPeriod = StatsPeriodOption.daily;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 통계 탭에 진입할 때마다 연속공부현황 및 잔디 provider 새로고침
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // refresh를 사용하여 즉시 새로고침 시작
      ref.refresh(currentStreakProvider(null));
      
      // 현재 월과 이전 월, 다음 월의 잔디 데이터 새로고침
      final now = DateTime.now();
      final currentMonth = DateTime(now.year, now.month, 1);
      final previousMonth = DateTime(
        now.month == 1 ? now.year - 1 : now.year,
        now.month == 1 ? 12 : now.month - 1,
        1,
      );
      final nextMonth = DateTime(
        now.month == 12 ? now.year + 1 : now.year,
        now.month == 12 ? 1 : now.month + 1,
        1,
      );
      
      ref.refresh(grassStatisticsProvider((currentMonth, null)));
      ref.refresh(grassStatisticsProvider((previousMonth, null)));
      ref.refresh(grassStatisticsProvider((nextMonth, null)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const TextHeader(text: '통계'),
            PeriodSelector(
              selectedOption: _selectedPeriod,
              onChange: (option) {
                setState(() {
                  _selectedPeriod = option;
                });
              },
            ),
            Expanded(
              child: _buildSelectedView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedView() {
    switch (_selectedPeriod) {
      case StatsPeriodOption.daily:
        return const DailyStatsView();
      case StatsPeriodOption.weekly:
        return const WeeklyStatsView();
      case StatsPeriodOption.monthly:
        return const MonthlyStatsView();
    }
  }
}

