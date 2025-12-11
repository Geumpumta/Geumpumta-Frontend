import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/stats/daily_statistics.dart';
import 'package:geumpumta/screens/stats/widgets/daily_usage_chart.dart';
import 'package:geumpumta/viewmodel/stats/daily_stats_viewmodel.dart';

class UsageTimeChartSection extends ConsumerStatefulWidget {
  const UsageTimeChartSection({
    super.key,
    this.title = '오늘의 사용 시간 그래프',
    this.slots,
    this.targetUserId,
    required this.selectedDate,
  });

  final String title;
  final List<DailySlot>? slots;
  final int? targetUserId;
  final DateTime selectedDate;

  @override
  ConsumerState<UsageTimeChartSection> createState() =>
      _UsageTimeChartSectionState();
}

class _UsageTimeChartSectionState extends ConsumerState<UsageTimeChartSection> {
  @override
  void initState() {
    super.initState();

    if (widget.slots != null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDailyStats();
    });
  }

  void _fetchDailyStats() {
    final formatted = _formatDateForApi(widget.selectedDate);

    ref
        .read(dailyStatsViewModelProvider(widget.targetUserId).notifier)
        .loadDailyStatistics(date: formatted);
  }



  String _formatDateForApi(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slots != null) {
      return _buildContainer(
        child: DailyUsageChart(slots: widget.slots!),
      );
    }

    final dailyState = ref.watch(dailyStatsViewModelProvider(widget.targetUserId));

    return _buildContainer(
      child: dailyState.when(
        data: (stats) => DailyUsageChart(slots: stats.slots),
        loading: () => const SizedBox(
          height: 120,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        error: (_, __) => const SizedBox(
          height: 120,
          child: Center(
            child: Text(
              '데이터를 불러올 수 없습니다.',
              style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
