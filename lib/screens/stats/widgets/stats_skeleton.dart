import 'package:flutter/material.dart';

class StatsSkeletonBlock extends StatelessWidget {
  const StatsSkeletonBlock({
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

class StatsChartSkeleton extends StatelessWidget {
  const StatsChartSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final barHeights = <double>[48, 82, 56, 94, 68, 78, 52, 88];

    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: barHeights
            .map(
              (height) => StatsSkeletonBlock(
                width: 20,
                height: height,
                radius: 10,
                color: const Color(0xFFE7F4FB),
              ),
            )
            .toList(),
      ),
    );
  }
}

class StatsValueSkeleton extends StatelessWidget {
  const StatsValueSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        StatsSkeletonBlock(width: 72, height: 28, radius: 10),
        SizedBox(height: 8),
        StatsSkeletonBlock(width: 54, height: 14, radius: 6),
      ],
    );
  }
}
