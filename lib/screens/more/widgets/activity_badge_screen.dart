import 'package:flutter/material.dart';
import 'package:geumpumta/models/entity/badge/activity_badge.dart';
import 'package:geumpumta/widgets/text_header/text_header.dart';

class ActivityBadgeScreen extends StatelessWidget {
  const ActivityBadgeScreen({super.key});

  static List<ActivityBadge> _mockBadges() {
    return [
      // [출석 관련]
      const ActivityBadge(id: 'att_1', name: '7일 연속 출석 (첫 주)', description: '첫 주 7일 연속 출석을 달성했어요.', isUnlocked: true, iconCodePoint: 0xe8b5),
      const ActivityBadge(id: 'att_2', name: '30일 연속 출석', description: '30일 연속 출석으로 잔디를 심었어요.', isUnlocked: false, iconCodePoint: 0xe9e2),
      const ActivityBadge(id: 'att_3', name: '출석 30일 누적', description: '총 30일 출석을 달성했어요.', isUnlocked: true, iconCodePoint: 0xe8b5),
      const ActivityBadge(id: 'att_4', name: '출석 120일 누적', description: '총 120일 출석을 달성했어요.', isUnlocked: false, iconCodePoint: 0xe8b5),
      const ActivityBadge(id: 'att_5', name: '출석 365일 누적', description: '1년 내내 출석한 당신, 대단해요!', isUnlocked: false, iconCodePoint: 0xe8b5),
      const ActivityBadge(id: 'att_6', name: '30일 연속 출석 기록', description: '30일 연속으로 출석 기록을 세웠어요.', isUnlocked: false, iconCodePoint: 0xe9e2),
      const ActivityBadge(id: 'att_7', name: '60일 연속 출석 기록', description: '60일 연속 출석을 달성했어요.', isUnlocked: false, iconCodePoint: 0xe9e2),
      const ActivityBadge(id: 'att_8', name: '100일 연속 출석 기록', description: '100일 연속 출석, 정말 대단해요!', isUnlocked: false, iconCodePoint: 0xe9e2),
      const ActivityBadge(id: 'att_9', name: '새벽 출석', description: '자정~06시에 접속했어요. 올빼미족!', isUnlocked: false, iconCodePoint: 0xe1b6),
      const ActivityBadge(id: 'att_10', name: '주말 출석', description: '토요일과 일요일 모두 출석했어요.', isUnlocked: true, iconCodePoint: 0xe16b),
      // [학습 시간 관련]
      const ActivityBadge(id: 'time_1', name: '시즌 100시간', description: '이번 시즌 100시간 학습을 달성했어요.', isUnlocked: true, iconCodePoint: 0xe425),
      const ActivityBadge(id: 'time_2', name: '시즌 300시간', description: '이번 시즌 300시간 학습을 달성했어요.', isUnlocked: false, iconCodePoint: 0xe425),
      const ActivityBadge(id: 'time_3', name: '시즌 500시간', description: '이번 시즌 500시간 학습을 달성했어요.', isUnlocked: false, iconCodePoint: 0xe425),
      const ActivityBadge(id: 'time_4', name: '시즌 1000시간', description: '이번 시즌 1000시간, 정말 대단해요!', isUnlocked: false, iconCodePoint: 0xe425),
      const ActivityBadge(id: 'time_5', name: '누적 1000시간', description: '총 학습 시간 1000시간을 달성했어요.', isUnlocked: false, iconCodePoint: 0xe425),
      const ActivityBadge(id: 'time_6', name: '누적 3000시간', description: '총 학습 시간 3000시간을 달성했어요.', isUnlocked: false, iconCodePoint: 0xe425),
      const ActivityBadge(id: 'time_7', name: '누적 5000시간', description: '총 학습 시간 5000시간을 달성했어요.', isUnlocked: false, iconCodePoint: 0xe425),
      const ActivityBadge(id: 'time_8', name: '누적 10000시간', description: '1만 시간의 법칙, 당신이 해냈어요!', isUnlocked: false, iconCodePoint: 0xe425),
      const ActivityBadge(id: 'time_9', name: '하루 10시간 달성', description: '하루에 10시간 이상 학습했어요.', isUnlocked: false, iconCodePoint: 0xe425),
      const ActivityBadge(id: 'time_10', name: '한달 300시간', description: '한 달에 300시간 학습을 달성했어요.', isUnlocked: false, iconCodePoint: 0xe425),
      // [랭킹 관련]
      const ActivityBadge(id: 'rank_1', name: '시즌 개인 랭킹 1위', description: '이번 시즌 개인 랭킹 1위를 달성했어요!', isUnlocked: false, iconCodePoint: 0xea79),
      const ActivityBadge(id: 'rank_2', name: '시즌 개인 랭킹 2위', description: '이번 시즌 개인 랭킹 2위를 달성했어요.', isUnlocked: false, iconCodePoint: 0xea79),
      const ActivityBadge(id: 'rank_3', name: '시즌 개인 랭킹 3위', description: '이번 시즌 개인 랭킹 3위를 달성했어요.', isUnlocked: true, iconCodePoint: 0xea79),
      const ActivityBadge(id: 'rank_4', name: '시즌 학과 랭킹 1위', description: '이번 시즌 학과 랭킹 1위를 달성했어요!', isUnlocked: false, iconCodePoint: 0xea79),
      const ActivityBadge(id: 'rank_5', name: '시즌 학과 랭킹 2위', description: '이번 시즌 학과 랭킹 2위를 달성했어요.', isUnlocked: false, iconCodePoint: 0xea79),
      const ActivityBadge(id: 'rank_6', name: '시즌 학과 랭킹 3위', description: '이번 시즌 학과 랭킹 3위를 달성했어요.', isUnlocked: false, iconCodePoint: 0xea79),
      const ActivityBadge(id: 'rank_7', name: '시즌 TOP 10% 진입', description: '이번 시즌 상위 10%에 진입했어요.', isUnlocked: false, iconCodePoint: 0xe838),
      const ActivityBadge(id: 'rank_8', name: '시즌 TOP 1% 진입', description: '이번 시즌 상위 1%에 진입했어요!', isUnlocked: false, iconCodePoint: 0xe838),
      // [학과/그룹 관련]
      const ActivityBadge(id: 'dept_1', name: '학과 내 1등', description: '이번 시즌 학과 1위를 달성했어요.', isUnlocked: false, iconCodePoint: 0xe80c),
      const ActivityBadge(id: 'dept_2', name: '학과 출석률 1위', description: '학과 출석률 1위를 달성했어요.', isUnlocked: false, iconCodePoint: 0xe80c),
      // [성장/첫 경험 관련]
      const ActivityBadge(id: 'first_1', name: '첫 로그인', description: '금풀타에 처음 로그인했어요. 환영해요!', isUnlocked: true, iconCodePoint: 0xe77e),
      const ActivityBadge(id: 'first_2', name: '첫 1시간 달성', description: '처음으로 1시간 학습을 달성했어요.', isUnlocked: true, iconCodePoint: 0xe425),
      const ActivityBadge(id: 'first_3', name: '첫 10시간 달성', description: '처음으로 10시간 학습을 달성했어요.', isUnlocked: false, iconCodePoint: 0xe425),
      const ActivityBadge(id: 'first_4', name: '첫 시즌 완주', description: '첫 시즌을 끝까지 완주했어요!', isUnlocked: false, iconCodePoint: 0xe153),
      // [특별/이벤트 관련]
      const ActivityBadge(id: 'evt_1', name: '1시즌 참여자', description: '1시즌에 참여한 특별한 기념 배지예요.', isUnlocked: false, iconCodePoint: 0xe8f6),
      const ActivityBadge(id: 'evt_2', name: '베타 참여자', description: '베타 테스트에 참여해 주셔서 감사해요!', isUnlocked: true, iconCodePoint: 0xe8f6),
      const ActivityBadge(id: 'evt_3', name: '시험 기간 집중', description: '기말고사 기간 N시간 달성 배지예요.', isUnlocked: false, iconCodePoint: 0xe80c),
      const ActivityBadge(id: 'evt_4', name: '새해 첫날 출석', description: '새해 첫날에도 출석한 당신!', isUnlocked: false, iconCodePoint: 0xe8b5),
      const ActivityBadge(id: 'evt_5', name: '크리스마스 출석', description: '크리스마스에도 함께해 줘서 고마워요.', isUnlocked: false, iconCodePoint: 0xe8f6),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final badges = _mockBadges();
    final Map<String, List<ActivityBadge>> sections = {
      '출석 관련': badges.where((b) => b.id.startsWith('att_')).toList(),
      '학습 시간 관련': badges.where((b) => b.id.startsWith('time_')).toList(),
      '랭킹 관련': badges.where((b) => b.id.startsWith('rank_')).toList(),
      '학과/그룹 관련': badges.where((b) => b.id.startsWith('dept_')).toList(),
      '성장/첫 경험 관련':
          badges.where((b) => b.id.startsWith('first_')).toList(),
      '특별/이벤트 관련': badges.where((b) => b.id.startsWith('evt_')).toList(),
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const TextHeader(text: '활동 배지'),
                Positioned(
                  left: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF0BAEFF)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.separated(
                  itemCount: sections.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final title = sections.keys.elementAt(index);
                    final list = sections[title] ?? const <ActivityBadge>[];
                    if (list.isEmpty) return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: list.length,
                          itemBuilder: (context, badgeIndex) {
                            final badge = list[badgeIndex];
                            return _BadgeGridItem(
                              badge: badge,
                              onTap: () => _showBadgeDetail(context, badge),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetail(BuildContext context, ActivityBadge badge) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _BadgeDetailSheet(badge: badge),
    );
  }
}

class _BadgeGridItem extends StatelessWidget {
  const _BadgeGridItem({
    required this.badge,
    required this.onTap,
  });

  final ActivityBadge badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isLocked = !badge.isUnlocked;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE0E0E0), 
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isLocked
                    ? const Color(0xFFE0E0E0)
                    : const Color(0xFFFFE082),
                borderRadius: BorderRadius.circular(12),
              ),
              child: isLocked
                  ? const Icon(Icons.lock, color: Color(0xFF9E9E9E), size: 28)
                  : Icon(
                      IconData(
                        badge.iconCodePoint ?? 0xe8b5,
                        fontFamily: 'MaterialIcons',
                      ),
                      color: const Color(0xFFE65100),
                      size: 28,
                    ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                badge.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isLocked ? const Color(0xFF9E9E9E) : const Color(0xFF333333),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _BadgeDetailSheet extends StatelessWidget {
  const _BadgeDetailSheet({required this.badge});

  final ActivityBadge badge;

  @override
  Widget build(BuildContext context) {
    final isLocked = !badge.isUnlocked;
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isLocked
                  ? const Color(0xFFE0E0E0)
                  : const Color(0xFFFFE082),
              borderRadius: BorderRadius.circular(16),
            ),
            child: isLocked
                ? const Icon(Icons.lock, color: Color(0xFF9E9E9E), size: 40)
                : Icon(
                    IconData(
                      badge.iconCodePoint ?? 0xe8b5,
                      fontFamily: 'MaterialIcons',
                    ),
                    color: const Color(0xFFE65100),
                    size: 40,
                  ),
          ),
          const SizedBox(height: 16),
          Text(
            badge.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            badge.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.4,
            ),
          ),
          if (badge.subDescription != null) ...[
            const SizedBox(height: 4),
            Text(
              badge.subDescription!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: badge.canSelectAsRepresentative
                  ? () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${badge.name}을(를) 대표 배지로 설정했어요.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF0BAEFF),
                disabledBackgroundColor: const Color(0xFFD9D9D9),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                badge.canSelectAsRepresentative
                    ? '나의 대표 배지로 사용하기'
                    : '잠금 해제 후 선택할 수 있어요',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
