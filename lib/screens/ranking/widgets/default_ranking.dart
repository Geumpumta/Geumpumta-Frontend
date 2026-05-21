import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/screens/ranking/widgets/per_day_or_week_or_month.dart';
import 'package:geumpumta/screens/ranking/widgets/period_option.dart';
import 'package:geumpumta/screens/ranking/widgets/ranking_board.dart';
import 'package:geumpumta/screens/ranking/widgets/ranking_my_info.dart';

import '../../../models/department.dart';
import '../../../provider/userState/user_info_state.dart';
import '../../../viewmodel/rank/rank_personal_viewmodel.dart';
import 'detail_ranking.dart';
import 'group_option.dart';

class DefaultRanking extends ConsumerStatefulWidget {
  const DefaultRanking({super.key, required this.refreshToken});

  final int refreshToken;

  @override
  ConsumerState<DefaultRanking> createState() => _DefaultRankingState();
}

class _DefaultRankingState extends ConsumerState<DefaultRanking> {
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
  void didUpdateWidget(covariant DefaultRanking oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshToken != widget.refreshToken) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchMyRanking());
    }
  }

  void _fetchMyRanking() {
    final vm = ref.read(rankPersonalViewModelProvider.notifier);
    switch (_selectedPeriod) {
      case PeriodOption.daily:
        vm.getDailyPersonalRanking(
          _normalizeDateForRequest(_selectedDate, _selectedPeriod),
        );
        break;
      case PeriodOption.weekly:
        vm.getWeeklyPersonalRanking(
          _normalizeDateForRequest(_selectedDate, _selectedPeriod),
        );
        break;
      case PeriodOption.monthly:
        vm.getMonthlyPersonalRanking(
          _normalizeDateForRequest(_selectedDate, _selectedPeriod),
        );
        break;
    }
  }

  DateTime? _normalizeDateForRequest(DateTime date, PeriodOption period) {
    final now = DateTime.now();
    switch (period) {
      case PeriodOption.daily:
        final target = DateTime(date.year, date.month, date.day);
        final today = DateTime(now.year, now.month, now.day);
        return target == today ? null : target;
      case PeriodOption.weekly:
        final target = DateTime(
          date.year,
          date.month,
          date.day,
        ).subtract(Duration(days: date.weekday - 1));
        final thisWeek = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: now.weekday - 1));
        return target == thisWeek ? null : target;
      case PeriodOption.monthly:
        final target = DateTime(date.year, date.month, 1);
        final thisMonth = DateTime(now.year, now.month, 1);
        return target == thisMonth ? null : target;
    }
  }

  int? _getMyTotalMillis() {
    final asyncState = ref.watch(rankPersonalViewModelProvider);

    return asyncState.maybeWhen(
      data: (response) {
        if (response == null) return null;
        return response.data.myRanking?.totalMillis;
      },
      orElse: () => null,
    );
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

    return Column(
      children: [
        RankingMyInfo(
          department: userInfoState?.department ?? Department.none,
          nickname: userInfoState?.nickName ?? '알 수 없음',
          duration: Duration(milliseconds: myRanking?.totalMillis ?? 0),
          ranking: myRanking?.rank ?? 5,
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
            refreshToken: widget.refreshToken,
            onGroupChanged: (g) {
              setState(() => _selectedGroup = g);
            },
            onDateChanged: (d) {
              setState(() => _selectedDate = d);
            },
          ),
        ),

        DetailRanking(
          selectedTime: _selectedDate,
          nickname: userInfoState?.nickName ?? '알 수 없음',
          imageUrl:
              userInfoState?.profileImage ??
              'https://i.namu.wiki/i/65UQVcoBA0aPl5FwSu5OvRT9v_B_yNBVs1VHah0ULM8ucqv95vBcMuzDDc8fb1ejGcrKNoa-IhsnMq5n7YEqwQ.webp',
          recordedTime: Duration(milliseconds: _getMyTotalMillis() ?? 0),
        ),
      ],
    );
  }
}
