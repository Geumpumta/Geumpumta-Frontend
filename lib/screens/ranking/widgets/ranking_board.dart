import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/department.dart';
import 'package:geumpumta/screens/ranking/widgets/period_option.dart';
import 'package:geumpumta/screens/ranking/widgets/ranking_bar.dart';
import 'package:geumpumta/screens/ranking/widgets/ranking_skeleton.dart';
import 'package:geumpumta/screens/ranking/widgets/square_option_button.dart';

import '../../../viewmodel/rank/rank_department_viewmodel.dart';
import '../../../viewmodel/rank/rank_personal_viewmodel.dart';
import 'custom_period_picker.dart';
import 'group_option.dart';

class RankingBoard extends ConsumerStatefulWidget {
  const RankingBoard({
    super.key,
    required this.periodOption,
    required this.selectedDate,
    required this.selectedGroup,
    required this.refreshToken,
    required this.onGroupChanged,
    required this.onDateChanged,
  });

  final PeriodOption periodOption;
  final DateTime selectedDate;
  final GroupOption selectedGroup;
  final int refreshToken;

  final void Function(GroupOption) onGroupChanged;
  final void Function(DateTime) onDateChanged;

  @override
  ConsumerState<RankingBoard> createState() => _RankingBoardState();
}

class _RankingBoardState extends ConsumerState<RankingBoard> {
  DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime _startOfWeek(DateTime date) {
    final normalized = _startOfDay(date);
    return normalized.subtract(Duration(days: normalized.weekday - 1));
  }

  DateTime _startOfMonth(DateTime date) => DateTime(date.year, date.month, 1);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchRanking();
    });
  }

  @override
  void didUpdateWidget(covariant RankingBoard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.periodOption != widget.periodOption ||
        oldWidget.selectedDate != widget.selectedDate ||
        oldWidget.selectedGroup != widget.selectedGroup ||
        oldWidget.refreshToken != widget.refreshToken) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchRanking();
      });
    }
  }

  DateTime? _convertDateForRequest(DateTime date, PeriodOption period) {
    final now = DateTime.now();

    switch (period) {
      case PeriodOption.daily:
        final targetDay = _startOfDay(date);
        if (targetDay == _startOfDay(now)) return null;
        return targetDay;

      case PeriodOption.weekly:
        final targetWeek = _startOfWeek(date);
        if (targetWeek == _startOfWeek(now)) return null;
        return targetWeek;

      case PeriodOption.monthly:
        final targetMonth = _startOfMonth(date);
        if (targetMonth == _startOfMonth(now)) return null;
        return targetMonth;
    }
  }

  String _convertDeletedNickname(String nickname) {
    return nickname.replaceAll('deleted_', '');
  }

  void _fetchRanking() {
    final period = widget.periodOption;

    final date = _convertDateForRequest(widget.selectedDate, period);

    if (widget.selectedGroup == GroupOption.personal) {
      final vm = ref.read(rankPersonalViewModelProvider.notifier);
      switch (period) {
        case PeriodOption.daily:
          vm.getDailyPersonalRanking(date);
          break;
        case PeriodOption.weekly:
          vm.getWeeklyPersonalRanking(date);
          break;
        case PeriodOption.monthly:
          vm.getMonthlyPersonalRanking(date);
          break;
      }
    } else {
      final vm = ref.read(rankDepartmentViewModelProvider.notifier);
      switch (period) {
        case PeriodOption.daily:
          vm.getDailyDepartmentRanking(date);
          break;
        case PeriodOption.weekly:
          vm.getWeeklyDepartmentRanking(date);
          break;
        case PeriodOption.monthly:
          vm.getMonthlyDepartmentRanking(date);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPersonal = widget.selectedGroup == GroupOption.personal;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildTopControls(),

          Expanded(
            child: isPersonal ? _buildPersonalList() : _buildDepartmentList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalList() {
    final asyncState = ref.watch(rankPersonalViewModelProvider);

    return asyncState.when(
      loading: () => const RankingListSkeleton(),
      error: (e, st) => Center(child: Text('오류가 발생했어요!')),
      data: (response) {
        if (response == null || response.data.topRanks.isEmpty) {
          return const Center(child: Text('개인 랭킹이 없습니다.'));
        }

        final list = response.data.topRanks;

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final data = list[index];
            return RankingBar(
              periodOption: widget.periodOption,
              dateTime: widget.selectedDate,
              ranking: data.rank,
              imgUrl: data.imageUrl,
              nickname: _convertDeletedNickname(data.username ?? '알 수 없음'),
              recordedTime: Duration(milliseconds: data.totalMillis),
              userId: data.userId,
            );
          },
        );
      },
    );
  }

  Widget _buildDepartmentList() {
    final asyncState = ref.watch(rankDepartmentViewModelProvider);

    return asyncState.when(
      loading: () => const RankingListSkeleton(),
      error: (e, st) => Center(child: Text('오류가 발생했어요!')),
      data: (response) {
        if (response == null || response.data.topRanks.isEmpty) {
          return const Center(child: Text('학과 랭킹이 없습니다.'));
        }

        final list = response.data.topRanks;

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final data = list[index];
            return RankingBar(
              periodOption: widget.periodOption,
              isDetailAvailable: false,
              dateTime: widget.selectedDate,
              ranking: data.rank,
              imgUrl:
                  'https://i.namu.wiki/i/65UQVcoBA0aPl5FwSu5OvRT9v_B_yNBVs1VHah0ULM8ucqv95vBcMuzDDc8fb1ejGcrKNoa-IhsnMq5n7YEqwQ.webp',
              nickname: data.departmentName.koreanName,
              recordedTime: Duration(milliseconds: data.totalMillis),
            );
          },
        );
      },
    );
  }

  Widget _buildTopControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          SquareOptionButton(
            text: '개인',
            isActive: widget.selectedGroup == GroupOption.personal,
            onSelect: () => widget.onGroupChanged(GroupOption.personal),
          ),

          SquareOptionButton(
            text: '학과',
            isActive: widget.selectedGroup == GroupOption.department,
            onSelect: () => widget.onGroupChanged(GroupOption.department),
          ),

          Expanded(
            child: CustomPeriodPicker(
              option: widget.periodOption,
              selectedDate: widget.selectedDate,
              onSelect: (newDate) => widget.onDateChanged(newDate),
            ),
          ),
        ],
      ),
    );
  }
}
