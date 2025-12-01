import 'package:flutter/material.dart';
import 'package:geumpumta/screens/ranking/widgets/details_in_modal.dart';

class DetailRanking extends StatefulWidget {
  const DetailRanking({
    super.key,
    required this.nickname,
    required this.recordedTime,
    required this.imageUrl,
  });

  final String nickname;
  final Duration recordedTime;
  final String imageUrl;

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
              ClipOval(
                child: Image.network(
                  widget.imageUrl,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
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
              showModalBottomSheet(
                backgroundColor: Color(0xFFFFFFFF),
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return DetailsInModal(
                    nickname: widget.nickname,
                    recordedTime: widget.recordedTime,
                    imageUrl: widget.imageUrl,
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
