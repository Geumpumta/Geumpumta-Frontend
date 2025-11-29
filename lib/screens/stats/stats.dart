import 'package:flutter/material.dart';
import 'package:geumpumta/screens/stats/widgets/daily_stats_view.dart';
import 'package:geumpumta/screens/stats/widgets/weekly_stats_view.dart';
import 'package:geumpumta/screens/stats/widgets/monthly_stats_view.dart';
import 'package:geumpumta/screens/stats/widgets/period_selector.dart';
import 'package:geumpumta/widgets/text_header/text_header.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  StatsPeriodOption _selectedPeriod = StatsPeriodOption.daily;

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

