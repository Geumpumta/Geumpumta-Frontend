import 'package:flutter/material.dart';

class DetailRanking extends StatefulWidget {
  const DetailRanking({
    super.key,
    required this.nickname,
    required this.recordedTime,
  });

  final String nickname;
  final Duration recordedTime;

  @override
  State<DetailRanking> createState() => _DetailRankingState();
}

class _DetailRankingState extends State<DetailRanking> {
  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(widget.recordedTime.inHours);
    final minutes = twoDigits(widget.recordedTime.inMinutes.remainder(60));
    final seconds = twoDigits(widget.recordedTime.inSeconds.remainder(60));

    String formattedDuration = '$hours:$minutes:$seconds';
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 3,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            spacing: 10,
            children: [
              Image.asset(
                'assets/image/login/main_img.png',
                width: 40,
                height: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  Text(
                    widget.nickname,
                    style: TextStyle(
                      color: Color(0xFF898989),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    formattedDuration,
                    style: TextStyle(color: Color(0xFF0BAEFF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const Text(
                          '내 순위 상세 보기',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('이번 주 순위 변화', style: TextStyle(fontSize: 16)),
                            Icon(Icons.trending_up, color: Colors.green),
                          ],
                        ),
                        const Divider(height: 30),
                        const Text(
                          '이번 주 상위 랭커들과의 비교:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        const Text('- 평균 학습 시간보다 2시간 길어요.'),
                        const Text('- 전체 순위 상위 3%에 속합니다.'),
                      ],
                    ),
                  );
                },
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFF8F9F9),
            ),
            child: Text('내 순위 보기', style: TextStyle(color: Color(0xFF898989))),
          ),
        ],
      ),
    );
  }
}
