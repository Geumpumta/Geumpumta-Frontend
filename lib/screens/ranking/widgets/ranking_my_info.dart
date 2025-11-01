import 'package:flutter/material.dart';
import 'package:geumpumta/models/department.dart';

class RankingMyInfo extends StatefulWidget {
  const RankingMyInfo({
    super.key,
    required this.department,
    required this.nickname,
    required this.duration,
    required this.ranking,
  });

  final Department department;
  final String nickname;
  final Duration duration;
  final int ranking;

  @override
  State<RankingMyInfo> createState() => _RankingMyInfoState();
}

class _RankingMyInfoState extends State<RankingMyInfo> {
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  String _fotmatRanking(int ranking) {
    if (ranking == 1)
      return 'assets/image/ranking/1st_medal.png';
    else if (ranking == 2)
      return 'assets/image/ranking/2nd_medal.png';
    else if (ranking == 3)
      return 'assets/image/ranking/3rd_medal.png';
    else
      return 'assets/image/ranking/etc_medal.png';
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = _formatDuration(widget.duration);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: Color(0xFFF8F9F9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                widget.department.koreanName,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFF898989),
                ),
              ),
              Text(
                widget.nickname,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                formattedTime,
                style: TextStyle(
                  color: Color(0xFF0BAEFF),
                  fontSize: 22,
                  fontWeight: FontWeight.w700
                ),
              ),
            ],
          ),
          Image.asset(_fotmatRanking(widget.ranking)),
        ],
      ),
    );
  }
}
