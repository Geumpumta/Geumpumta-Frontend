import 'package:flutter/material.dart';

/// 통계 카드 위젯
/// 일간 통계 정보를 표시하는 카드
class StatsCard extends StatelessWidget {
  const StatsCard({
    super.key,
    required this.stats,
  });

  final List<StatItem> stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ...stats.asMap().entries.map((entry) {
            final isLast = entry.key == stats.length - 1;
            return Column(
              children: [
                StatsRow(
                  label: entry.value.label,
                  value: entry.value.value,
                ),
                if (!isLast) const SizedBox(height: 12),
              ],
            );
          }),
        ],
      ),
    );
  }
}

/// 통계 행 위젯
class StatsRow extends StatelessWidget {
  const StatsRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
          ),
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
}

/// 통계 아이템 데이터 모델
class StatItem {
  const StatItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

