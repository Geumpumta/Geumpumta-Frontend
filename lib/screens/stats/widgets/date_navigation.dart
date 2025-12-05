import 'package:flutter/material.dart';

/// 이전/다음 날짜로 이동할 수 있는 네비게이션 바
class DateNavigation extends StatelessWidget {
  const DateNavigation({
    super.key,
    required this.selectedDate,
    required this.onPreviousDate,
    required this.onNextDate,
    required this.minDate,
  });

  final DateTime selectedDate;
  final VoidCallback onPreviousDate;
  final VoidCallback onNextDate;
  final DateTime minDate;

  @override
  Widget build(BuildContext context) {
    // 오늘 날짜 (시간 제거)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final nextRaw = selectedDate.add(const Duration(days: 1));
    final nextDate = DateTime(nextRaw.year, nextRaw.month, nextRaw.day);

    final prevRaw = selectedDate.subtract(const Duration(days: 1));
    final prevDate = DateTime(prevRaw.year, prevRaw.month, prevRaw.day);

    final canGoNext = !nextDate.isAfter(today);
    final canGoPrev = !prevDate.isBefore(minDate);
    final dateStr =
        '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: canGoPrev ? onPreviousDate : null,
            child: Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: canGoPrev ? const Color(0xFF666666) : Colors.grey.shade300,
            ),
          ),
          Text(
            dateStr,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: canGoNext ? onNextDate : null,
            child: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: canGoNext ? const Color(0xFF666666) : Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }
}
