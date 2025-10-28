import 'package:flutter/material.dart';

/// 이전/다음 날짜로 이동할 수 있는 네비게이션 바
class DateNavigation extends StatelessWidget {
  const DateNavigation({
    super.key,
    required this.selectedDate,
    required this.onPreviousDate,
    required this.onNextDate,
  });

  final DateTime selectedDate;
  final VoidCallback onPreviousDate;
  final VoidCallback onNextDate;

  @override
  Widget build(BuildContext context) {
    final dateStr = '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일';

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
            onTap: onPreviousDate,
            child: const Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: Color(0xFF666666),
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
            onTap: onNextDate,
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}

