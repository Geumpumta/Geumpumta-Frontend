import 'package:flutter/material.dart';
import 'package:geumpumta/routes/app_routes.dart';
import 'package:geumpumta/widgets/section_title/section_title.dart';

class NoticeSection extends StatelessWidget {
  const NoticeSection({
    super.key,
    this.notices = const ['1번 내용', '2번 내용', '3번 내용'],
  });

  final List<String> notices;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: '공지사항',
          showMoreButton: true,
          onMorePressed: () {
            Navigator.pushNamed(
              context,
              AppRoutes.placeholder,
              arguments: {'title': '공지사항 전체보기'},
            );
          },
        ),
        const SizedBox(height: 12),
        ...notices.map(
          (notice) => _NoticeItem(
            title: notice,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.placeholder,
                arguments: {'title': notice},
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NoticeItem extends StatelessWidget {
  const _NoticeItem({
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF555555),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFCCCCCC),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

