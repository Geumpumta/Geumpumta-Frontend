import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/dto/board/board_list_item_dto.dart';
import 'package:geumpumta/provider/api_provider.dart';
import 'package:geumpumta/routes/app_routes.dart';
import 'package:geumpumta/widgets/section_title/section_title.dart';

class NoticeSection extends ConsumerStatefulWidget {
  const NoticeSection({super.key});

  @override
  ConsumerState<NoticeSection> createState() => _NoticeSectionState();
}

class _NoticeSectionState extends ConsumerState<NoticeSection> {
  List<BoardListItemDto>? _notices;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  Future<void> _loadNotices() async {
    try {
      final boardApi = ref.read(boardApiProvider);
      final response = await boardApi.getBoardList();

      if (response.success && response.data.isNotEmpty) {
        setState(() {
          // 상위 3개만 가져오기
          _notices = response.data.take(3).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: '공지사항',
          showMoreButton: true,
          onMorePressed: () {
            Navigator.pushNamed(context, AppRoutes.boardList);
          },
        ),
        const SizedBox(height: 12),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else if (_notices == null || _notices!.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '공지사항이 없습니다.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF999999),
              ),
            ),
          )
        else
          ..._notices!.map(
            (notice) => _NoticeItem(
              title: notice.title,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.boardDetail,
                  arguments: {'boardId': notice.id},
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

