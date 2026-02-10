import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/screens/ranking/widgets/default_ranking.dart';
import 'package:geumpumta/screens/ranking/widgets/season_ranking.dart';

import '../../widgets/custom_dropdown/custom_dropdown.dart';


enum RankingTab { ranking, season }

extension RankingTabExtension on RankingTab {
  String get label {
    switch (this) {
      case RankingTab.ranking:
        return '랭킹';
      case RankingTab.season:
        return '시즌';
    }
  }
}

RankingTab _tabFromLabel(String v) {
  if (v == '랭킹') return RankingTab.ranking;
  return RankingTab.season;
}

class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key});

  @override
  ConsumerState<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen> {
  RankingTab _selectedTab = RankingTab.ranking;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Center(
              child: CustomDropdown(
                value: _selectedTab.label,
                items: const ['랭킹', '시즌'],
                onTap: (v) {
                  if (v == null) return;
                  setState(() => _selectedTab = _tabFromLabel(v));
                },
              ),
            ),
          ),
          Expanded(
            child: _selectedTab == RankingTab.ranking
                ? const DefaultRanking()
                : const SeasonRanking(),
          ),
        ],
      ),
    );
  }
}
