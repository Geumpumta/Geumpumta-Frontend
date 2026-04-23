import 'package:flutter/material.dart';

class MoreSkeletonBlock extends StatelessWidget {
  const MoreSkeletonBlock({
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

class NoticeSectionSkeleton extends StatelessWidget {
  const NoticeSectionSkeleton({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: MoreSkeletonBlock(width: double.infinity, height: 14)),
              SizedBox(width: 12),
              MoreSkeletonBlock(width: 18, height: 18, radius: 9),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePageSkeleton extends StatelessWidget {
  const ProfilePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F0F0)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MoreSkeletonBlock(
                    width: 72,
                    height: 72,
                    radius: 36,
                    color: Color(0xFFE7F4FB),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MoreSkeletonBlock(width: 120, height: 20),
                        SizedBox(height: 8),
                        MoreSkeletonBlock(width: 150, height: 13),
                        SizedBox(height: 20),
                        MoreSkeletonBlock(width: double.infinity, height: 14),
                        SizedBox(height: 10),
                        MoreSkeletonBlock(width: 180, height: 14),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              MoreSkeletonBlock(width: double.infinity, height: 46, radius: 8),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F0F0)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MoreSkeletonBlock(width: 80, height: 16),
              MoreSkeletonBlock(width: 16, height: 16, radius: 8),
            ],
          ),
        ),
      ],
    );
  }
}

class BadgeGridSkeleton extends StatelessWidget {
  const BadgeGridSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MoreSkeletonBlock(
                width: 56,
                height: 56,
                radius: 12,
                color: Color(0xFFE7F4FB),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: MoreSkeletonBlock(width: double.infinity, height: 12),
              ),
              SizedBox(height: 6),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: MoreSkeletonBlock(width: double.infinity, height: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BoardListSkeleton extends StatelessWidget {
  const BoardListSkeleton({super.key, this.itemCount = 8});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(child: MoreSkeletonBlock(width: double.infinity, height: 14)),
              SizedBox(width: 12),
              MoreSkeletonBlock(width: 72, height: 12),
              SizedBox(width: 8),
              MoreSkeletonBlock(width: 18, height: 18, radius: 9),
            ],
          ),
        );
      },
    );
  }
}

class BoardDetailSkeleton extends StatelessWidget {
  const BoardDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MoreSkeletonBlock(width: 220, height: 20),
          SizedBox(height: 12),
          MoreSkeletonBlock(width: 90, height: 12),
          SizedBox(height: 24),
          MoreSkeletonBlock(width: double.infinity, height: 14),
          SizedBox(height: 10),
          MoreSkeletonBlock(width: double.infinity, height: 14),
          SizedBox(height: 10),
          MoreSkeletonBlock(width: double.infinity, height: 14),
          SizedBox(height: 10),
          MoreSkeletonBlock(width: 260, height: 14),
          SizedBox(height: 10),
          MoreSkeletonBlock(width: double.infinity, height: 14),
          SizedBox(height: 10),
          MoreSkeletonBlock(width: 230, height: 14),
        ],
      ),
    );
  }
}
