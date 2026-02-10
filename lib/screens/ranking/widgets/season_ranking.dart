import 'package:flutter/material.dart';
import 'package:geumpumta/screens/ranking/widgets/remain_time.dart';
import 'package:geumpumta/widgets/custom_dropdown/custom_dropdown.dart';

class SeasonRanking extends StatefulWidget {
  const SeasonRanking({super.key});

  @override
  State<SeasonRanking> createState() => _SeasonRankingState();
}

class _SeasonRankingState extends State<SeasonRanking> {
  /// 임시 DropDown 아이템
  final List<String> _seasonItems = [
    'Season 1',
    'Season 2',
    'Season 3',
    'Season 4',
  ];

  late String _selectedSeason;

  @override
  void initState() {
    super.initState();
    _selectedSeason = _seasonItems[0];
  }

  void _onDropdownTap(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedSeason = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomDropdown(
                value: _selectedSeason,
                items: _seasonItems,
                onTap: _onDropdownTap,
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.info_outline_rounded),
              ),
            ],
          ),
          RemainTime(dueDate: DateTime(2026, 03, 04)),
        ],
      ),
    );
  }
}
