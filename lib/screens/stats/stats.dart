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
    // 통계 탭에 진입할 때마다 연속공부현황 provider 새로고침
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(currentStreakProvider(null));
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

