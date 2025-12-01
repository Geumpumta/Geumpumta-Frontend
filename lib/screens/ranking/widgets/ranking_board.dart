import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/department.dart';
import 'package:geumpumta/screens/ranking/widgets/ranking_bar.dart';
import 'package:geumpumta/screens/ranking/widgets/square_option_button.dart';

import '../../../viewmodel/rank/rank_department_viewmodel.dart';
import '../../../viewmodel/rank/rank_personal_viewmodel.dart';
import '../ranking.dart';
import 'custom_period_picker.dart';

class RankingBoard extends ConsumerStatefulWidget {
  const RankingBoard({
    super.key,
    required this.periodOption,
    required this.selectedDate,
    required this.selectedGroup,
    required this.onGroupChanged,
    required this.onDateChanged,
  });

  final PeriodOption periodOption;
  final DateTime selectedDate;
  final GroupOption selectedGroup;

  final void Function(GroupOption) onGroupChanged;
  final void Function(DateTime) onDateChanged;

  @override
  ConsumerState<RankingBoard> createState() => _RankingBoardState();
}

class _RankingBoardState extends ConsumerState<RankingBoard> {
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
        oldWidget.selectedGroup != widget.selectedGroup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchRanking();
      });
    }
  }

  DateTime? _convertDateForRequest(DateTime date, PeriodOption period) {
    final now = DateTime.now();

    bool isSameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    bool isSameWeek(DateTime a, DateTime b) {
      int week(DateTime d) => ((d.day - d.weekday + 10) ~/ 7);
      return a.year == b.year && week(a) == week(b);
    }

    bool isSameMonth(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month;

    switch (period) {
      case PeriodOption.daily:
        if (isSameDay(date, now)) return null;
        return date;

      case PeriodOption.weekly:
        if (isSameWeek(date, now)) return null;
        return date;

      case PeriodOption.monthly:
        if (isSameMonth(date, now)) return null;
        return date;
    }
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('오류 발생: $e')),
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
              ranking: data.rank,
              imgUrl: data.imageUrl,
              nickname: data.username ?? '알 수 없음',
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('오류 발생: $e')),
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
