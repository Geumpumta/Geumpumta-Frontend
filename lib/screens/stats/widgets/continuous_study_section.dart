import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/screens/stats/widgets/contribution_grass.dart';
import 'package:geumpumta/viewmodel/stats/grass_stats_viewmodel.dart';

class ContinuousStudySection extends ConsumerWidget {
  const ContinuousStudySection({
    super.key,
    this.manualStreakDays,
    this.targetUserId,
  });

  final int? manualStreakDays;
  final int? targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = manualStreakDays != null
        ? AsyncValue<int>.data(manualStreakDays!)
        : ref.watch(currentStreakProvider(targetUserId));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '연속 공부 현황',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          ContributionGrass(targetUserId: targetUserId),
          const SizedBox(height: 16),
          Center(
            child: streakAsync.when(
              data: (streak) => Column(
              children: [
                Text(
                    '$streak일',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '연속 공부',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
              ),
              loading: () => const SizedBox(
                height: 40,
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (_, __) => Column(
                children: const [
                  Text(
                    '--일',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '연속 공부',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

