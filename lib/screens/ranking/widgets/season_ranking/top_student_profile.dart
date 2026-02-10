import 'package:flutter/material.dart';
import 'package:geumpumta/models/department.dart';

class TopStudentProfile extends StatelessWidget {
  final int rank;
  final String imageUrl;
  final String nickname;
  final Duration totalTime;
  final Department department;

  const TopStudentProfile({
    super.key,
    required this.rank,
    required this.imageUrl,
    required this.nickname,
    required this.totalTime,
    required this.department,
  });

  Widget _buildMedal(int rank) {
    if (rank == 1)
      return Image.asset('assets/image/ranking/1st_medal.png', width: 50);
    else if (rank == 2)
      return Image.asset('assets/image/ranking/2nd_medal.png', width: 50);
    else if (rank == 3)
      return Image.asset('assets/image/ranking/3rd_medal.png', width: 50);
    else
      return Image.asset('assets/image/ranking/etc_medal.png', width: 50);
  }

  double _formattedImgSize(int rank) {
    if (rank == 1)
      return 40;
    else if (rank == 2)
      return 32;
    else if (rank == 3)
      return 25;
    else
      return 20;
  }

  String _formatStudyTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMedal(rank),
        SizedBox(height: 10),
        CircleAvatar(
          radius: _formattedImgSize(rank),
          backgroundImage: NetworkImage(imageUrl),
        ),
        SizedBox(height: 10),
        Text(
          nickname,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        SizedBox(height: 4),
        Text(
          _formatStudyTime(totalTime),
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: Color(0xFF0BAEFF),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xFFF8F9F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(department.koreanName, style: TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
}
