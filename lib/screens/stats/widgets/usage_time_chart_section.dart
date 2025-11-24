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
  });

  final String title;
  final List<DailySlot>? slots;
  final int? targetUserId;

  @override
  ConsumerState<UsageTimeChartSection> createState() =>
      _UsageTimeChartSectionState();
}

class _UsageTimeChartSectionState
    extends ConsumerState<UsageTimeChartSection> {
  @override
  void initState() {
    super.initState();
    if (widget.targetUserId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchDailyStats());
    }
  }

  void _fetchDailyStats() {
    if (widget.targetUserId == null) return;
    final today = DateTime.now();
    final formatted = _formatDateForApi(today);
    ref
        .read(dailyStatsViewModelProvider.notifier)
        .loadDailyStatistics(
          date: formatted,
          targetUserId: widget.targetUserId,
        );
  }

  String _formatDateForApi(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    // slots가 직접 제공되면 그것을 사용
    if (widget.slots != null) {
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
            DailyUsageChart(slots: widget.slots!),
          ],
        ),
      );
    }

    // targetUserId가 제공되면 데이터를 가져와서 사용
    if (widget.targetUserId != null) {
      final dailyState = ref.watch(dailyStatsViewModelProvider);

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
            dailyState.when(
              data: (stats) => DailyUsageChart(slots: stats.slots),
              loading: () => const SizedBox(
                height: 120,
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (_, __) => const SizedBox(
                height: 120,
                child: Center(
                  child: Text(
                    '데이터를 불러올 수 없습니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 둘 다 없으면 빈 리스트 사용
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
          DailyUsageChart(slots: const <DailySlot>[]),
        ],
      ),
    );
  }
}

