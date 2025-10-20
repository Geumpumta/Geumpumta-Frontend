import 'package:flutter/material.dart';

/// 섹션 제목 위젯
/// 재사용 가능한 섹션 제목 스타일
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.showMoreButton = false,
    this.onMorePressed,
  });

  final String title;
  final bool showMoreButton;
  final VoidCallback? onMorePressed;

  @override
  Widget build(BuildContext context) {
    if (showMoreButton && onMorePressed != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          GestureDetector(
            onTap: onMorePressed,
            child: const Row(
              children: [
                Text(
                  '전체보기',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0BAEFF),
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Color(0xFF0BAEFF),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF333333),
      ),
    );
  }
}

