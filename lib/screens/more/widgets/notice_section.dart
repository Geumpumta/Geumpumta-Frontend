import 'package:flutter/material.dart';
import 'package:geumpumta/widgets/section_title/section_title.dart';
import 'package:geumpumta/widgets/menu_item/menu_item.dart';
import 'package:geumpumta/routes/app_routes.dart';

class NoticeSection extends StatelessWidget {
  const NoticeSection({
    super.key,
    this.notices = const ['1번 내용', '2번 내용', '3번 내용'],
  });

  final List<String> notices;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
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
          ...notices.map((notice) => MenuItem(
                title: notice,
                textColor: const Color(0xFF333333),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.placeholder,
                    arguments: {'title': notice},
                  );
                },
              )),
        ],
      ),
    );
  }
}

