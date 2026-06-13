import 'package:flutter/material.dart';
import 'package:geumpumta/screens/ranking/widgets/period_option.dart';

import 'details_in_modal.dart';

class RankingBar extends StatefulWidget {
  const RankingBar({
    super.key,
    required this.ranking,
    required this.imgUrl,
    required this.nickname,
    required this.recordedTime,
    this.userId,
    this.dateTime,
    this.isDetailAvailable = true,
    this.periodOption,
  });

  final int ranking;
  final String imgUrl;
  final String nickname;
  final Duration recordedTime;
  final int? userId;
  final DateTime? dateTime;
  final bool? isDetailAvailable;
  final PeriodOption? periodOption;

  @override
  State<RankingBar> createState() => _RankingBarState();
}

class _RankingBarState extends State<RankingBar> {
  static const double _rankSlotWidth = 28;

  double _rankFontSize(int ranking) {
    final digitCount = ranking.abs().toString().length;

    if (digitCount <= 2) return 18;
    if (digitCount == 3) return 15;
    if (digitCount == 4) return 12.5;
    return 10.5;
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(widget.recordedTime.inHours);
    final minutes = twoDigits(widget.recordedTime.inMinutes.remainder(60));
    final seconds = twoDigits(widget.recordedTime.inSeconds.remainder(60));

    String formattedDuration = '$hours:$minutes:$seconds';
    final rankingText = widget.ranking.toString();
    final rankFontSize = _rankFontSize(widget.ranking);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 12,
              children: [
                SizedBox(
                  width: _rankSlotWidth,
                  child: Align(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        rankingText,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: rankFontSize,
                        ),
                      ),
                    ),
                  ),
                ),
                ClipOval(
                  child: Image.network(
                    widget.imgUrl,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Image.asset(
                        'assets/image/login/main_img.png',
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.nickname,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF898989),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        formattedDuration,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF0BAEFF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          (widget.isDetailAvailable == true)
              ? TextButton(
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
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) {
                        return DetailsInModal(
                          periodOption: widget.periodOption,
                          selectedDate:
                              widget.dateTime ?? DateTime(2002, 11, 19),
                          nickname: widget.nickname,
                          recordedTime: widget.recordedTime,
                          imageUrl: widget.imgUrl,
                          targetUserId: widget.userId,
                        );
                      },
                    );
                  },
                  child: Text('상세보기', style: TextStyle(fontSize: 14)),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
