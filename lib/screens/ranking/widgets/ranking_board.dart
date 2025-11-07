import 'package:flutter/material.dart';
import 'package:geumpumta/screens/ranking/ranking.dart';
import 'package:geumpumta/screens/ranking/widgets/custom_period_picker.dart';
import 'package:geumpumta/screens/ranking/widgets/ranking_bar.dart';
import 'package:geumpumta/screens/ranking/widgets/square_option_button.dart';

import '../../../models/dummy_ranking_data.dart';

enum GroupOption { personal, department }

extension GroupOptionExtension on GroupOption {
  String get koreanName {
    switch (this) {
      case GroupOption.personal:
        return '개인';
      case GroupOption.department:
        return '학과';
    }
  }
}

enum DifferenceOption { up, maintain, down }

extension DifferenceOptionExtension on DifferenceOption {
  Image get icons {
    switch (this) {
      case DifferenceOption.up:
        return Image.asset('assets/image/ranking/up_icon.png');
      case DifferenceOption.down:
        return Image.asset('assets/image/ranking/down_icon.png');
      case DifferenceOption.maintain:
        return Image.asset('assets/image/ranking/maintain_icon.png');
    }
  }
}

// 이 위젯에서 랭킹 데이터 받아와서 관리해야할듯. ranking.dart에는 지금 너무 상태가 많음
class RankingBoard extends StatefulWidget {
  const RankingBoard({super.key, required this.periodOption});

  final PeriodOption periodOption;

  @override
  State<RankingBoard> createState() => _RankingBoardState();
}

class _RankingBoardState extends State<RankingBoard> {
  DateTime _selectedPeriodDate = DateTime.now();
  GroupOption _selectedGroup = GroupOption.personal;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
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
                SquareOptionButton(
                  text: '개인',
                  isActive: _selectedGroup == GroupOption.personal,
                  onSelect: () {
                    setState(() {
                      _selectedGroup = GroupOption.personal;
                    });
                  },
                ),
                SquareOptionButton(
                  text: '학과',
                  isActive: _selectedGroup == GroupOption.department,
                  onSelect: () {
                    setState(() {
                      _selectedGroup = GroupOption.department;
                    });
                  },
                ),
                Expanded(
                  child: CustomPeriodPicker(
                    option: widget.periodOption,
                    selectedDate: _selectedPeriodDate,
                    onSelect: (d) {
                      setState(() {
                        _selectedPeriodDate = d;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: dummyRankingList.map((data) {
                return RankingBar(
                  ranking: data.ranking,
                  differenceOption: data.differenceOption,
                  imgUrl: data.imgUrl,
                  nickname: data.nickname,
                  recordedTime: data.recordedTime,
                );
              }).toList(),
            ),
          )

        ],
      ),
    );
  }
}
