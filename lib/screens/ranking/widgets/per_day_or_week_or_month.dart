import 'package:flutter/material.dart';
import 'package:geumpumta/screens/ranking/widgets/custom_select_button.dart';

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

class PerDayOrWeekOrMonth extends StatefulWidget {
  const PerDayOrWeekOrMonth({super.key});

  @override
  State<PerDayOrWeekOrMonth> createState() => _PerDayOrWeekOrMonthState();
}

class _PerDayOrWeekOrMonthState extends State<PerDayOrWeekOrMonth> {
  PeriodOption _selectedOption = PeriodOption.daily;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xFFD9D9D9))),
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomSelectButton(
            onClick: () {
              setState(() {
                _selectedOption = PeriodOption.daily;
              });
            },
            text: '일간',
            isActive: _selectedOption == PeriodOption.daily,
          ),
          CustomSelectButton(
            onClick: () {
              setState(() {
                _selectedOption = PeriodOption.weekly;
              });
            },
            text: '주간',
            isActive: _selectedOption == PeriodOption.weekly,
          ),
          CustomSelectButton(
            onClick: () {
              setState(() {
                _selectedOption = PeriodOption.monthly;
              });
            },
            text: '월간',
            isActive: _selectedOption == PeriodOption.monthly,
          ),
        ],
      ),
    );
  }
}
