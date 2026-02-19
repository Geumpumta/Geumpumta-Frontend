import 'package:flutter/material.dart';
import 'package:geumpumta/models/department.dart';
import 'package:geumpumta/models/dto/rank/get_season_ranking_response_dto.dart';
import 'package:geumpumta/screens/ranking/widgets/ranking_bar.dart';
import 'package:geumpumta/screens/ranking/widgets/season_ranking/top_student_profile.dart';

class TopThreeAndRankings extends StatelessWidget {
  final List<SeasonRankingItem> rankings;

  const TopThreeAndRankings({
    super.key,
    required this.rankings,
  });

  @override
  Widget build(BuildContext context) {
    SeasonRankingItem? byRank(int r) {
      for (final x in rankings) {
        if (x.rank == r) {
          return x;
        }
      }
      return null;
    }

    final first = byRank(1);
    final second = byRank(2);
    final third = byRank(3);

    if (rankings.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            '데이터가 없습니다.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

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
                          imageUrl: second.imageUrl.isEmpty
                              ? 'https://picsum.photos/100?season-2'
                              : second.imageUrl,
                          nickname: second.username,
                          totalTime: Duration(milliseconds: second.totalMillis),
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
                          imageUrl: first.imageUrl.isEmpty
                              ? 'https://picsum.photos/100?season-1'
                              : first.imageUrl,
                          nickname: first.username,
                          totalTime: Duration(milliseconds: first.totalMillis),
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
                          imageUrl: third.imageUrl.isEmpty
                              ? 'https://picsum.photos/100?season-3'
                              : third.imageUrl,
                          nickname: third.username,
                          totalTime: Duration(milliseconds: third.totalMillis),
                          department: DepartmentParser.fromKorean(third.department),
                        ),
                      ),
              ),
            ],
          ),
        ),

        ...rankings.map((item) {
          return RankingBar(
            ranking: item.rank,
            imgUrl: item.imageUrl.isEmpty
                ? 'https://picsum.photos/100?season-${item.rank}'
                : item.imageUrl,
            nickname: item.username,
            recordedTime: Duration(milliseconds: item.totalMillis),
            isDetailAvailable: false,
          );
        }),
      ],
    );
  }
}
