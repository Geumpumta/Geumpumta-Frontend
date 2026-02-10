import 'package:flutter/material.dart';
import 'package:geumpumta/models/department.dart';
import 'package:geumpumta/screens/ranking/widgets/ranking_bar.dart';
import 'package:geumpumta/screens/ranking/widgets/season_ranking/top_student_profile.dart';

class TopThreeAndRankings extends StatelessWidget {
  const TopThreeAndRankings({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_RankingDummy> dummyList = [
      _RankingDummy(
        department: Department.computerEngineering.koreanName,
        rank: 1,
        nickname: '민우',
        totalStudyTime: const Duration(hours: 12, minutes: 34),
        imageUrl: 'https://picsum.photos/100?1',
      ),
      _RankingDummy(
        department: Department.mechanicalSystemsEngineering.koreanName,
        rank: 2,
        nickname: '예원',
        totalStudyTime: const Duration(hours: 10, minutes: 12),
        imageUrl: 'https://picsum.photos/100?2',
      ),
      _RankingDummy(
        department: Department.electronicSystems.koreanName,
        rank: 3,
        nickname: '지훈',
        totalStudyTime: const Duration(hours: 9, minutes: 45),
        imageUrl: 'https://picsum.photos/100?3',
      ),
      _RankingDummy(
        department: Department.industrialEngineering.koreanName,
        rank: 4,
        nickname: '세빈',
        totalStudyTime: const Duration(hours: 8, minutes: 20),
        imageUrl: 'https://picsum.photos/100?4',
      ),
      _RankingDummy(
        department: Department.chemicalBioMaterials.koreanName,
        rank: 5,
        nickname: '도윤',
        totalStudyTime: const Duration(hours: 7, minutes: 55),
        imageUrl: 'https://picsum.photos/100?5',
      ),
    ];

    String formatDuration(Duration d) {
      final h = d.inHours.toString().padLeft(2, '0');
      final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
      return '$h:$m';
    }

    _RankingDummy? byRank(int r) {
      for (final x in dummyList) {
        if (x.rank == r) return x;
      }
      return null;
    }

    final first = byRank(1);
    final second = byRank(2);
    final third = byRank(3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: second == null
                    ? const SizedBox.shrink()
                    : Align(
                        alignment: Alignment.topLeft,
                        child: TopStudentProfile(
                          rank: second.rank,
                          imageUrl: second.imageUrl,
                          nickname: second.nickname,
                          totalTime: second.totalStudyTime,
                          department: DepartmentParser.fromKorean(
                            second.department,
                          ),
                        ),
                      ),
              ),
              Expanded(
                child: first == null
                    ? const SizedBox.shrink()
                    : Align(
                        alignment: Alignment.topCenter,
                        child: TopStudentProfile(
                          rank: first.rank,
                          imageUrl: first.imageUrl,
                          nickname: first.nickname,
                          totalTime: first.totalStudyTime,
                          department: DepartmentParser.fromKorean(
                            first.department,
                          ),
                        ),
                      ),
              ),
              Expanded(
                child: third == null
                    ? const SizedBox.shrink()
                    : Align(
                        alignment: Alignment.topRight,
                        child: TopStudentProfile(
                          rank: third.rank,
                          imageUrl: third.imageUrl,
                          nickname: third.nickname,
                          totalTime: third.totalStudyTime,
                          department: DepartmentParser.fromKorean(third.department),
                        ),
                      ),
              ),
            ],
          ),
        ),

        ...dummyList.map((item) {
          return RankingBar(
            ranking: item.rank,
            imgUrl: item.imageUrl,
            nickname: item.nickname,
            recordedTime: item.totalStudyTime,
            isDetailAvailable: false,
          );
        }),
      ],
    );
  }
}

class _RankingDummy {
  final String department;
  final int rank;
  final String nickname;
  final Duration totalStudyTime;
  final String imageUrl;

  const _RankingDummy({
    required this.department,
    required this.rank,
    required this.nickname,
    required this.totalStudyTime,
    required this.imageUrl,
  });
}
