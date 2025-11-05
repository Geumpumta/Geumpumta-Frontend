import 'package:flutter/material.dart';
import 'package:geumpumta/screens/stats/widgets/daily_usage_chart.dart';

class UsageTimeChartSection extends StatelessWidget {
  const UsageTimeChartSection({
    super.key,
    this.title = '오늘의 사용 시간 그래프',
  });

  final String title;

  @override
  Widget build(BuildContext context) {
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
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          const DailyUsageChart(),
        ],
      ),
    );
  }
}

