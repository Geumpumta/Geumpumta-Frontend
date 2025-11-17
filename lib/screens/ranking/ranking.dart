import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/department.dart';
import 'package:geumpumta/screens/ranking/widgets/detail_ranking.dart';
import 'package:geumpumta/screens/ranking/widgets/per_day_or_week_or_month.dart';
import 'package:geumpumta/screens/ranking/widgets/ranking_board.dart';
import 'package:geumpumta/screens/ranking/widgets/ranking_my_info.dart';
import 'package:geumpumta/viewmodel/rank/rank_department_viewmodel.dart';
import 'package:geumpumta/viewmodel/rank/rank_personal_viewmodel.dart';
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

class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key});

  @override
  ConsumerState<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen> {
  PeriodOption _selectedPeriodOption = PeriodOption.daily;

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(rankPersonalViewModelProvider.notifier);
      notifier.getDailyPersonalRanking(DateTime.now());
    });

  }


  @override
  Widget build(BuildContext context) {
    final personalViewModel = ref.watch(rankPersonalViewModelProvider.notifier);
    final departmentViewModel = ref.watch(rankDepartmentViewModelProvider.notifier);

    void fetchDepartmentRanking(PeriodOption option) {
      final now = DateTime.now();

      switch (option) {
        case PeriodOption.daily:
          departmentViewModel.getDailyDepartmentRanking(now);
          break;
        case PeriodOption.weekly:
          departmentViewModel.getWeeklyDepartmentRanking(now);
          break;
        case PeriodOption.monthly:
          departmentViewModel.getMonthlyDepartmentRanking(now);
          break;
      }
    }

    void fetchPersonalRanking(PeriodOption option) {
      final now = DateTime.now();

      switch (option) {
        case PeriodOption.daily:
          personalViewModel.getDailyPersonalRanking(now);
          break;
        case PeriodOption.weekly:
          personalViewModel.getWeeklyPersonalRanking(now);
          break;
        case PeriodOption.monthly:
          personalViewModel.getMonthlyPersonalRanking(now);
          break;
      }
    }

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
          Expanded(child: RankingBoard(periodOption: _selectedPeriodOption)),
          DetailRanking(
            nickname: '미누리',
            recordedTime: Duration(hours: 22, minutes: 19, seconds: 39),
          ),
        ],
      ),
    );
  }
}
