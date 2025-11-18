import 'package:flutter/material.dart';

import 'details_in_modal.dart';

class RankingBar extends StatefulWidget {
  const RankingBar({
    super.key,
    required this.ranking,
    required this.imgUrl,
    required this.nickname,
    required this.recordedTime,
  });

  final int ranking;
  final String imgUrl;
  final String nickname;
  final Duration recordedTime;

  @override
  State<RankingBar> createState() => _RankingBarState();
}

class _RankingBarState extends State<RankingBar> {
  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(widget.recordedTime.inHours);
    final minutes = twoDigits(widget.recordedTime.inMinutes.remainder(60));
    final seconds = twoDigits(widget.recordedTime.inSeconds.remainder(60));

    String formattedDuration = '$hours:$minutes:$seconds';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 18,
            children: [
              Text(
                widget.ranking.toString(),
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              Image.network(
                widget.imgUrl,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nickname,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF898989),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    formattedDuration,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF0BAEFF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          TextButton(
            style: TextButton.styleFrom(
              fixedSize: Size(80, 40),
              backgroundColor: Color(0xFFCEEFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
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
                  );
                },
              );
            },
            child: Text('상세보기', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
