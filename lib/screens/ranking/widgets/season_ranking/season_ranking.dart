import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geumpumta/models/dto/rank/get_season_ranking_response_dto.dart';
import 'package:geumpumta/screens/ranking/widgets/season_ranking/my_info_in_season_rank.dart';
import 'package:geumpumta/screens/ranking/widgets/season_ranking/remain_time.dart';
import 'package:geumpumta/screens/ranking/widgets/season_ranking/top_three_and_rankings.dart';
import 'package:geumpumta/viewmodel/rank/season_rank_viewmodel.dart';
import 'package:geumpumta/widgets/custom_dropdown/custom_dropdown.dart';
import 'package:geumpumta/provider/userState/user_info_state.dart';

class SeasonRanking extends ConsumerStatefulWidget {
  const SeasonRanking({super.key});

  @override
  ConsumerState<SeasonRanking> createState() => _SeasonRankingState();
}

class _SeasonRankingState extends ConsumerState<SeasonRanking> {
  int? _currentSeasonId;
  int? _currentSeasonNumber;
  int? _currentSeasonLabelYear;
  int? _selectedSeasonNumber;
  int _selectedYear = DateTime.now().year;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();

    _loadCurrentUserId();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(seasonRankViewModelProvider.notifier).getCurrentSeasonRanking();
    });
  }

  Future<void> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    if (accessToken == null || accessToken.isEmpty) return;

    final parsed = _parseUserIdFromJwt(accessToken);
    if (!mounted) return;
    setState(() {
      _currentUserId = parsed;
    });
  }

  int? _parseUserIdFromJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      String normalized = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      switch (normalized.length % 4) {
        case 1:
          normalized += '===';
          break;
        case 2:
          normalized += '==';
          break;
        case 3:
          normalized += '=';
          break;
      }

      final payload = jsonDecode(utf8.decode(base64Decode(normalized)));
      if (payload is! Map<String, dynamic>) return null;
      return _toInt(payload['userId']) ??
          _toInt(payload['id']) ??
          _toInt(payload['USER_ID']) ??
          _toInt(payload['sub']);
    } catch (_) {
      return null;
    }
  }

  int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  int _seasonNumberFromDate(DateTime date) {
    final month = date.month;
    if (month >= 1 && month <= 2) return 1;
    if (month >= 3 && month <= 6) return 2;
    if (month >= 7 && month <= 8) return 3;
    return 4;
  }

  int _seasonIndex(int year, int seasonNumber) {
    return (year * 4) + (seasonNumber - 1);
  }

  int? _seasonIdFromSelection(int selectedSeasonNumber, int selectedYear) {
    if (_currentSeasonId == null ||
        _currentSeasonNumber == null ||
        _currentSeasonLabelYear == null) {
      return null;
    }
    final currentIndex = _seasonIndex(
      _currentSeasonLabelYear!,
      _currentSeasonNumber!,
    );
    final targetIndex = _seasonIndex(selectedYear, selectedSeasonNumber);
    final seasonDelta = targetIndex - currentIndex;
    return _currentSeasonId! + seasonDelta;
  }

  String _seasonLabel(int year, int seasonNumber) {
    return '$year-$seasonNumber시즌';
  }

  Future<void> _onDropdownTap(String? newValue) async {
    if (newValue == null) return;
    final normalized = newValue.replaceAll('시즌', '');
    final parts = normalized.split('-');
    if (parts.length != 2) return;
    final year = int.tryParse(parts[0]);
    final seasonNumber = int.tryParse(parts[1]);
    if (year == null || seasonNumber == null) return;

    setState(() {
      _selectedYear = year;
      _selectedSeasonNumber = seasonNumber;
    });

    final isCurrentSeason = year == _currentSeasonLabelYear &&
        seasonNumber == _currentSeasonNumber;
    if (isCurrentSeason) {
      await ref.read(seasonRankViewModelProvider.notifier).getCurrentSeasonRanking();
      return;
    }

    final targetSeasonId = _seasonIdFromSelection(seasonNumber, year);
    if (targetSeasonId == null) return;
    await ref
        .read(seasonRankViewModelProvider.notifier)
        .getClosedSeasonRanking(targetSeasonId);
  }

  void _syncCurrentSeasonState(SeasonRankingData data) {
    final currentByDate =
        DateTime.tryParse(data.startDate) ?? DateTime.now();
    _currentSeasonId ??= data.seasonId;
    _currentSeasonLabelYear ??= currentByDate.year;
    _currentSeasonNumber ??= _seasonNumberFromDate(currentByDate);
    _selectedYear = _currentSeasonLabelYear!;
    _selectedSeasonNumber ??= _currentSeasonNumber;
  }

  String _percentageText(int rank, int totalCount) {
    if (rank <= 0 || totalCount <= 0) return '0.0%';
    final value = ((totalCount - rank + 1) / totalCount) * 100;
    return '${value.clamp(0, 100).toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    final seasonState = ref.watch(seasonRankViewModelProvider);
    final userInfo = ref.watch(userInfoStateProvider);
    final response = seasonState.valueOrNull;
    final data = response?.data;
    if (data != null) {
      _syncCurrentSeasonState(data);
    }

    final isLoading = seasonState.isLoading;
    final rankings = data?.rankings ?? <SeasonRankingItem>[];

    final seasonItems = <String>[
      _seasonLabel(_selectedYear, 1),
      _seasonLabel(_selectedYear, 2),
      _seasonLabel(_selectedYear, 3),
      _seasonLabel(_selectedYear, 4),
    ];
    final selectedLabel = _seasonLabel(
      _selectedYear,
      _selectedSeasonNumber ?? _currentSeasonNumber ?? 1,
    );

    SeasonRankingItem? myByUserId;
    if (_currentUserId != null) {
      for (final item in rankings) {
        if (item.userId == _currentUserId) {
          myByUserId = item;
          break;
        }
      }
    }

    SeasonRankingItem? myByNickname;
    final nickName = userInfo?.nickName;
    if (nickName != null && nickName.isNotEmpty) {
      for (final item in rankings) {
        if (item.username == nickName) {
          myByNickname = item;
          break;
        }
      }
    }

    final myRanking = myByUserId ?? myByNickname;
    final myImageUrl = myRanking?.imageUrl.isNotEmpty == true
        ? myRanking!.imageUrl
        : (userInfo?.profileImage?.isNotEmpty == true
            ? userInfo!.profileImage!
            : 'https://picsum.photos/100?my-season');
    final myNickname = myRanking?.username.isNotEmpty == true
        ? myRanking!.username
        : (userInfo?.nickName ?? '');
    final myRank = myRanking?.rank ?? 0;
    final myDuration = Duration(milliseconds: myRanking?.totalMillis ?? 0);
    final myPercentage =
        myRanking == null ? '0.0%' : _percentageText(myRanking.rank, rankings.length);
    final dueDate = DateTime.tryParse(data?.endDate ?? '') ?? DateTime.now();

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomDropdown(
                  value: selectedLabel,
                  items: seasonItems,
                  onTap: _onDropdownTap,
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.info_outline_rounded),
                ),
              ],
            ),
            RemainTime(dueDate: dueDate),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: CircularProgressIndicator(),
              )
            else
              MyInfoInSeasonRank(
                imageUrl: myImageUrl,
                nickname: myNickname,
                rank: '$myRank',
                percentage: myPercentage,
                totalStudyTime: myDuration,
              ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: CircularProgressIndicator(),
              )
            else
              TopThreeAndRankings(rankings: rankings),
          ],
        ),
      ),
    );
  }
}
