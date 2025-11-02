import 'package:flutter/material.dart';
import 'package:geumpumta/models/department.dart';
import 'package:geumpumta/screens/ranking/widgets/per_day_or_week_or_month.dart';
import 'package:geumpumta/screens/ranking/widgets/ranking_board.dart';
import 'package:geumpumta/screens/ranking/widgets/ranking_my_info.dart';
import 'package:geumpumta/widgets/text_header/text_header.dart';

enum PeriodOption { daily, weekly, monthly }

extension PeriodOptionExtension on PeriodOption {
  String get koreanName {
    switch (this) {
      case PeriodOption.daily:
        return '일간';
      case PeriodOption.weekly:
        return '주간';
      case PeriodOption.monthly:
        return '월간';
    }
  }
}

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  PeriodOption _selectedPeriodOption = PeriodOption.daily;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          TextHeader(text: '랭킹'),
          RankingMyInfo(
            department: Department.computerEngineering,
            nickname: '미누리',
            duration: Duration(hours: 12, minutes: 55, seconds: 10),
            ranking: 1,
          ),
          PerDayOrWeekOrMonth(
            selectedOption: _selectedPeriodOption,
            onChange: (option) {
              setState(() {
                _selectedPeriodOption = option;
              });
            },
          ),
          RankingBoard(periodOption: _selectedPeriodOption),
        ],
      ),
    );
  }
}
