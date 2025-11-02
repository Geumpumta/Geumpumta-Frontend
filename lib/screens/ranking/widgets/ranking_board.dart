import 'package:flutter/material.dart';
import 'package:geumpumta/screens/ranking/widgets/square_option_button.dart';

class RankingBoard extends StatefulWidget {
  const RankingBoard({super.key});

  @override
  State<RankingBoard> createState() => _RankingBoardState();
}

class _RankingBoardState extends State<RankingBoard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFFFFF),
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SquareOptionButton(text: '전체', isActive: true),
                SquareOptionButton(text: '학과', isActive: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
