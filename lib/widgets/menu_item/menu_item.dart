import 'package:flutter/material.dart';

/// 메뉴 아이템 위젯
/// 재사용 가능한 메뉴 아이템 스타일
class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.title,
    this.onTap,
    this.textColor,
    this.iconColor,
    this.showIcon = true,
  });

  final String title;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? iconColor;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final defaultTextColor = textColor ?? const Color(0xFF0BAEFF);
    final defaultIconColor = iconColor ?? const Color(0xFF0BAEFF);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: defaultTextColor,
              ),
            ),
            if (showIcon)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: defaultIconColor,
              ),
          ],
        ),
      ),
    );
  }
}

