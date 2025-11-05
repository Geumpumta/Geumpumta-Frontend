import 'package:flutter/material.dart';

class MotivationalMessage extends StatelessWidget {
  const MotivationalMessage({
    super.key,
    this.missedTime = '00:00:00',
    this.message = '집중력을 높여보세요!',
  });

  final String missedTime;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.hourglass_empty,
            color: Color(0xFF0BAEFF),
            size: 32,
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
              ),
              children: [
                const TextSpan(text: '오늘은 '),
                TextSpan(
                  text: missedTime,
                  style: const TextStyle(
                    color: Color(0xFF0BAEFF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: '을 놓쳤습니다'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}

