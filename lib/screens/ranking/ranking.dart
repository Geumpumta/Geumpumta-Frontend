import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/department.dart';
import 'package:geumpumta/provider/userState/user_info_state.dart';
import 'package:geumpumta/screens/ranking/widgets/detail_ranking.dart';
import 'package:geumpumta/screens/ranking/widgets/per_day_or_week_or_month.dart';
import 'package:geumpumta/screens/ranking/widgets/ranking_board.dart';
import 'package:geumpumta/screens/ranking/widgets/ranking_my_info.dart';
import 'package:geumpumta/widgets/text_header/text_header.dart';

import '../../viewmodel/rank/rank_personal_viewmodel.dart';

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

enum GroupOption { personal, department }

class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key});

  @override
  ConsumerState<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen> {
  PeriodOption _selectedPeriod = PeriodOption.daily;
  DateTime _selectedDate = DateTime.now();
  GroupOption _selectedGroup = GroupOption.personal;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = ref.read(rankPersonalViewModelProvider.notifier);
      vm.getDailyPersonalRanking(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(rankPersonalViewModelProvider);
    final userInfoState = ref.watch(userInfoStateProvider);

    final myRanking = asyncState.when(
      data: (response) => response?.data.myRanking,
      loading: () => null,
      error: (e, st) => null,
    );

    return SafeArea(
      child: Column(
        children: [
          const TextHeader(text: '랭킹'),

          RankingMyInfo(
            department: userInfoState?.department ?? Department.none,
            nickname: userInfoState?.nickName ?? '이름 없음',
            duration: Duration(milliseconds: userInfoState?.totalMillis ?? 0),
            ranking: 1,
          ),

          PerDayOrWeekOrMonth(
            selectedOption: _selectedPeriod,
            onChange: (option) {
              setState(() {
                _selectedPeriod = option;
              });
            },
          ),

          Expanded(
            child: RankingBoard(
              periodOption: _selectedPeriod,
              selectedDate: _selectedDate,
              selectedGroup: _selectedGroup,
              onGroupChanged: (g) {
                setState(() => _selectedGroup = g);
              },
              onDateChanged: (d) {
                setState(() => _selectedDate = d);
              },
            ),
          ),

          DetailRanking(
            nickname: userInfoState?.nickName ?? '알 수 없음',
            imageUrl:
                userInfoState?.profileImage ??
                'https://i.namu.wiki/i/65UQVcoBA0aPl5FwSu5OvRT9v_B_yNBVs1VHah0ULM8ucqv95vBcMuzDDc8fb1ejGcrKNoa-IhsnMq5n7YEqwQ.webp',
            recordedTime: Duration(
              milliseconds: userInfoState?.totalMillis ?? 0,
            ),
          ),
        ],
      ),
    );
  }
}
