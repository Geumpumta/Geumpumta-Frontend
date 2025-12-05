import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/screens/stats/widgets/contribution_grass.dart';
import 'package:geumpumta/viewmodel/stats/grass_stats_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContinuousStudySection extends ConsumerStatefulWidget {
  const ContinuousStudySection({
    super.key,
    this.manualStreakDays,
    this.selectedDate,
    this.targetUserId,
  });

  final int? manualStreakDays;
  final DateTime? selectedDate;
  final int? targetUserId;

  @override
  ConsumerState<ContinuousStudySection> createState() => _ContinuousStudySectionState();
}

class _ContinuousStudySectionState extends ConsumerState<ContinuousStudySection> {
  @override
  void initState() {
    super.initState();
    // 위젯이 생성될 때마다 provider 새로고침
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.manualStreakDays == null) {
        ref.refresh(currentStreakProvider(widget.targetUserId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final streakAsync = widget.manualStreakDays != null
        ? AsyncValue<int>.data(widget.manualStreakDays!)
        : ref.watch(currentStreakProvider(widget.targetUserId));

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
          ContributionGrass(
            selectedMonth: widget.selectedDate != null
                ? DateTime(widget.selectedDate!.year, widget.selectedDate!.month)
                : null,
            targetUserId: widget.targetUserId,
          ),
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
              error: (error, stackTrace) {
                debugPrint('연속공부현황 로드 실패: $error');
                return const Column(
                  children: [
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

