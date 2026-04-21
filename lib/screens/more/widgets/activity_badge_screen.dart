import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/badge/my_badge.dart';
import 'package:geumpumta/screens/more/widgets/more_skeleton.dart';
import 'package:geumpumta/viewmodel/badge/badge_viewmodel.dart';
import 'package:geumpumta/widgets/text_header/text_header.dart';

class ActivityBadgeScreen extends ConsumerStatefulWidget {
  const ActivityBadgeScreen({super.key});

  @override
  ConsumerState<ActivityBadgeScreen> createState() =>
      _ActivityBadgeScreenState();
}

class _ActivityBadgeScreenState extends ConsumerState<ActivityBadgeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activityBadgeListViewModelProvider.notifier).loadMyBadges();
    });
  }

  @override
  Widget build(BuildContext context) {
    final badgeState = ref.watch(activityBadgeListViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
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
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: badgeState.when(
                  loading: () => const BadgeGridSkeleton(),
                  error: (error, stackTrace) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '활동 배지를 불러오지 못했어요.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            ref
                                .read(activityBadgeListViewModelProvider.notifier)
                                .loadMyBadges();
                          },
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  ),
                  data: (badges) {
                    if (badges.isEmpty) {
                      return const Center(
                        child: Text(
                          '표시할 배지가 없어요.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.85,
                          ),
                      itemCount: badges.length,
                      itemBuilder: (context, index) {
                        final badge = badges[index];
                        return _BadgeGridItem(
                          badge: badge,
                          onTap: () => _showBadgeDetail(context, badge),
                        );
                      },
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

  void _showBadgeDetail(BuildContext context, MyBadge badge) {
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

  final MyBadge badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isLocked = !badge.owned;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isLocked ? const Color(0xFFE0E0E0) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isLocked
                      ? const Color(0xFFD0D0D0)
                      : const Color(0xFFEEEEEE),
                ),
              ),
              child: isLocked
                  ? const Icon(Icons.lock, color: Color(0xFF9E9E9E), size: 28)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        badge.iconUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.emoji_events_outlined,
                          color: Color(0xFF9E9E9E),
                          size: 28,
                        ),
                      ),
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
                  color: isLocked
                      ? const Color(0xFF9E9E9E)
                      : const Color(0xFF333333),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeDetailSheet extends ConsumerWidget {
  const _BadgeDetailSheet({required this.badge});

  final MyBadge badge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLocked = !badge.owned;
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
              color: isLocked ? const Color(0xFFE0E0E0) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isLocked ? const Color(0xFFD0D0D0) : const Color(0xFFEEEEEE),
              ),
            ),
            child: isLocked
                ? const Icon(Icons.lock, color: Color(0xFF9E9E9E), size: 40)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      badge.iconUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.emoji_events_outlined,
                        color: Color(0xFF9E9E9E),
                        size: 36,
                      ),
                    ),
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
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLocked
                  ? null
                  : () async {
                      try {
                        await ref
                            .read(badgeViewModelProvider.notifier)
                            .setRepresentativeBadge(badge.code);
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${badge.name}을(를) 대표 배지로 설정했어요.',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('대표 배지 설정에 실패했어요. 다시 시도해 주세요.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
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
                isLocked ? '잠금 해제 후 선택할 수 있어요' : '나의 대표 배지로 사용하기',
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
