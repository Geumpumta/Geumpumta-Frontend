import 'package:flutter/material.dart';

class MyInfoInSeasonRank extends StatelessWidget {
  final String imageUrl;
  final String nickname;
  final String rank;
  final Duration totalStudyTime;
  final String percentage;

  const MyInfoInSeasonRank({
    super.key,
    required this.imageUrl,
    required this.nickname,
    required this.rank,
    required this.percentage,
    required this.totalStudyTime,
  });

  @override
  Widget build(BuildContext context) {
    String _formatStudyTime(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');

      final hours = twoDigits(duration.inHours);
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));

      return '$hours:$minutes:$seconds';
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9F9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFFEEEEEE), width: 1),
      ),
      child: Column(
        spacing: 10,
        children: [
          Row(
            spacing: 15,
            children: [
              CircleAvatar(radius: 20, backgroundImage: NetworkImage(imageUrl)),
              Text(
                nickname,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
            ],
          ),
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    '내 랭킹',
                    style: TextStyle(
                      color: Color(0xFF898989),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(rank, style: TextStyle(fontWeight: FontWeight.w800)),
                ],
              ),
              Container(
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.2),
                ),
              ),
              Column(
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Text(
                        '총 시간',
                        style: TextStyle(
                          color: Color(0xFF898989),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _formatStudyTime(totalStudyTime),
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      Text(
                        '백분위',
                        style: TextStyle(
                          color: Color(0xFF898989),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        percentage,
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
