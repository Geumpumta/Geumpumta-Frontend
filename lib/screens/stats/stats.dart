import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/screens/stats/widgets/daily_stats_view.dart';
import 'package:geumpumta/screens/stats/widgets/weekly_stats_view.dart';
import 'package:geumpumta/screens/stats/widgets/monthly_stats_view.dart';
import 'package:geumpumta/screens/stats/widgets/period_selector.dart';
import 'package:geumpumta/viewmodel/stats/grass_stats_viewmodel.dart';
import 'package:geumpumta/widgets/text_header/text_header.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key, required this.refreshToken});

  final int refreshToken;

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  StatsPeriodOption _selectedPeriod = StatsPeriodOption.daily;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _refreshSupportingData(),
    );
  }

  @override
  void didUpdateWidget(covariant StatsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshToken != widget.refreshToken) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _refreshSupportingData(),
      );
    }
  }

  void _refreshSupportingData() {
    ref.invalidate(currentStreakProvider(null));

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

    ref.invalidate(grassStatisticsProvider((currentMonth, null)));
    ref.invalidate(grassStatisticsProvider((previousMonth, null)));
    ref.invalidate(grassStatisticsProvider((nextMonth, null)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
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
            Expanded(child: _buildSelectedView()),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedView() {
    switch (_selectedPeriod) {
      case StatsPeriodOption.daily:
        return DailyStatsView(refreshToken: widget.refreshToken);
      case StatsPeriodOption.weekly:
        return WeeklyStatsView(refreshToken: widget.refreshToken);
      case StatsPeriodOption.monthly:
        return MonthlyStatsView(refreshToken: widget.refreshToken);
    }
  }
}
