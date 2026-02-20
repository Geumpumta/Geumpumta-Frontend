import 'package:flutter/material.dart';

class RemainTime extends StatelessWidget {
  final DateTime dueDate;

  const RemainTime({super.key, required this.dueDate});

  String _formatDateTime() {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) {
      return '마감됨';
    }

    if (difference.inDays > 0) {
      final days = difference.inDays;
      final hours = difference.inHours % 24;
      return '$days일 $hours시간';
    }

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours == 0 && minutes == 0) {
      return '마감 임박';
    }

    return '$hours시간 $minutes분';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          width: 1,
          color: const Color(0xFFD9D9D9),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '남은 시간',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            _formatDateTime(),
            style: const TextStyle(
              color: Color(0xFF2F80ED),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}