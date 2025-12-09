import 'package:flutter/material.dart';
import 'package:geumpumta/models/entity/stats/daily_statistics.dart';
import 'package:geumpumta/screens/stats/widgets/continuous_study_section.dart';
import 'package:geumpumta/screens/stats/widgets/usage_time_chart_section.dart';

class DetailsInModal extends StatelessWidget {
  const DetailsInModal({
    super.key,
    required this.nickname,
    required this.recordedTime,
    required this.imageUrl,
    this.targetUserId,
  });

  final String nickname;
  final Duration recordedTime;
  final String imageUrl;
  final int? targetUserId;

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(recordedTime.inHours);
    final minutes = twoDigits(recordedTime.inMinutes.remainder(60));
    final seconds = twoDigits(recordedTime.inSeconds.remainder(60));

    String formattedDuration = '$hours:$minutes:$seconds';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                spacing: 10,
                children: [
                  ClipOval(
                    child: Image.network(
                      imageUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/image/login/main_img.png',
                          width: 40,
                          height: 40,
                        );
                      },
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 3,
                    children: [
                      Text(
                        nickname,
                        style: TextStyle(
                          color: Color(0xFF898989),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        formattedDuration,
                        style: TextStyle(
                          color: Color(0xFF0BAEFF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF8F9F9),
                ),
                child: Text(
                  '상대 순위 보기',
                  style: TextStyle(color: Color(0xFF898989)),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          ContinuousStudySection(targetUserId: targetUserId),
          SizedBox(height: 30),
          UsageTimeChartSection(targetUserId: targetUserId),
        ],
      ),
    );
  }
}
