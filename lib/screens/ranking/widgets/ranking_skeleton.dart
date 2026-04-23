import 'package:flutter/material.dart';

class RankingSkeletonBlock extends StatelessWidget {
  const RankingSkeletonBlock({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
    this.color = const Color(0xFFF0F0F0),
  });

  final double width;
  final double height;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class RankingListSkeleton extends StatelessWidget {
  const RankingListSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: itemCount,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                RankingSkeletonBlock(width: 18, height: 18, radius: 6),
                SizedBox(width: 18),
                RankingSkeletonBlock(
                  width: 40,
                  height: 40,
                  radius: 20,
                  color: Color(0xFFE7F4FB),
                ),
                SizedBox(width: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RankingSkeletonBlock(width: 92, height: 16, radius: 6),
                    SizedBox(height: 8),
                    RankingSkeletonBlock(width: 76, height: 14, radius: 6),
                  ],
                ),
              ],
            ),
            const RankingSkeletonBlock(width: 68, height: 32, radius: 10),
          ],
        );
      },
    );
  }
}

class SeasonMyInfoSkeleton extends StatelessWidget {
  const SeasonMyInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: const Column(
        children: [
          RankingSkeletonBlock(
            width: 64,
            height: 64,
            radius: 32,
            color: Color(0xFFE7F4FB),
          ),
          SizedBox(height: 14),
          RankingSkeletonBlock(width: 110, height: 18, radius: 8),
          SizedBox(height: 10),
          RankingSkeletonBlock(width: 72, height: 28, radius: 10),
          SizedBox(height: 10),
          RankingSkeletonBlock(width: 140, height: 16, radius: 8),
        ],
      ),
    );
  }
}
